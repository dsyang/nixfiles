# Add dashes to a UUID without them
fix-uuid() {
  pbpaste | sed 's|\([a-z0-9]\{8\}\)\([a-z0-9]\{4\}\)\([a-z0-9]\{4\}\)\([a-z0-9]\{4\}\)|\1-\2-\3-\4-|' | tee /dev/stderr | pbcopy
}

# Remove dashes from a UUID with them
unfix-uuid() {
  pbpaste | sed 's|-||g' | tee /dev/stderr | pbcopy
}