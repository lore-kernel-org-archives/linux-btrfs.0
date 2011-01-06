From: Josef Bacik <josef@redhat.com>
Subject: Offline Deduplication for Btrfs V2
Date: Thu,  6 Jan 2011 13:24:58 -0500
Message-ID: <1294338300-24259-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just a quick update, I've dropped the hashing stuff in favor of doing a memcmp
in the kernel to make sure the data is still the same.  The thing that takes a
while is reading the data up from disk, so doing a memcmp of the entire buffer
isn't that big of a deal, not to mention there's a possiblity for malicious
users if there is a problem with the hashing algorithms we use.  Plus this makes
the interface simpler.  Thanks,

Josef
