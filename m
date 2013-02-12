Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab3BLU5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 15:57:35 -0500
Date: Tue, 12 Feb 2013 12:57:31 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
Message-ID: <20130212205731.GA11872@lenny.home.zabbo.net>
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
 <5119C379.7080305@redhat.com>
 <5119D813.40101@jp.fujitsu.com>
 <511A8228.9060109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <511A8228.9060109@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > 
> > So, I chose this one. (read /proc/swaps)
> 
> Sure, I think your change is good.  I just think perhaps mkfs should also try
> to open O_EXCL after all those other tests, as a last safety check.

I think mkfs should first try an O_EXCL open.  If that works it doesn't
need to do any of this work to try and predict if the open will fail.

After it fails it can poke around a bit to try and give nice context for
why it failed.  But it might not be able to because /proc/swaps is
fundamentally unreliable.

> >>>           file = av[optind++];
> >>> +        ret = is_swap_device(file);

The input string is a CWD-realtive path.  You'd at least want to use
realpath() to get it to a canonical name.  So it's not full of junk like
"./" and "../../.." which won't be present in /proc/swaps.

> >>> +    char    buf[1024];

Use PATH_MAX so it doesn't fail on absurd but allowed file names.
(Where on earth does 1024 come from?)

> >>> +    if ((f = fopen("/proc/swaps", "r")) == NULL)
> >>> +        return -errno;

As was pointed out, there's no reason this failure should stop mkfs.
/proc/swaps might not be available or allowed and I should still be able
to do an unpriviledged "./mkfs ./myfile; ./btrfs-debug-tree ./myfile".

> >>> +        if (strcmp(file, buf) == 0) {
> >>> +            ret = 1;
> >>> +            break;
> >>> +        }

The command line path that lead to the inode might not be the path for
the inode that is in /proc/swaps.  Bind mounts, chroot, name spaces,
hard links, etc, all make it possible -- though unlikely -- that mkfs
simply won't be able to tell if the path names are related.

Also, /proc/swaps escapes whitespace in file names.  So you could be
comparing "swap file" with "swap\040file".

> >>> +        if ((stat(buf, &st_buf) == 0) && S_ISBLK(st_buf.st_mode) &&
> >>> +            rdev == st_buf.st_rdev) {
> >>> +            ret = 1;
> >>> +            break;
> >>> +        }

One possible alternative is to then try and open every swap file path to
see if it points to the same inode as the path mkfs was given.  But you
might not have access to the paths and we're back to the unpriviledged
failure case.

- z
