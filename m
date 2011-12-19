From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Error: btrfs bad tree block
Date: Mon, 19 Dec 2011 13:33:05 +0100
Message-ID: <20111219123305.GA13596@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	Hello,

It seems BTRFS finally gave up on me! :-)  I've been using as my main FS
for quite a while and this time I'm not able to fix this issue.

I've tried mounting with -o clear_cache, zeroing the log and changing
super but I'm still getting this over and over:

btrfs bad tree block start 0 204055724032

This is running 3.2.0-rc6-00005-ga36bfdd

I've tried btrfsck but it segfaults haha...

I didn't do anything special before that except I had a bunch of
subvolumes and I deleted them.

Any idea what I could try next?

Thanks in advance,
-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
