Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3DORBE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 13:01:04 -0400
Message-ID: <516C324D.30200@redhat.com>
Date: Mon, 15 Apr 2013 12:01:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Dan McGrath <danmcgrath.ca@gmail.com>
CC: Jan Alexander Steffens <jan.steffens@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com> <1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com> <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com> <CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
In-Reply-To: <CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/15/13 11:45 AM, Dan McGrath wrote:
> Jan,
> 
> I got a chance to sit down and dig a little bit deeper into
> `fsck.xfs`. Here is what I discovered.
> 
> The "(a|A|y|p)" options in the XFS script appear to be nothing more
> than the expected `fsck` options that imply automated checks (as is
> clearly implied by the use of AUTO). While I have yet to specifically
> test the capitalized "A", my guess is that it matches the "-A" options
> from fsck(8) for when the system is going through the fstab. The
> syntax itself appears to assume that the dev name is the last param
> (as indicated by the argc/$#, which gets eval'd into the DEV
> variable).
> 
> After doing some tests with a hacked up version of the `fsck.xfs`
> script, it would appear that the generic `fsck` script calls each
> script in order and passes it some parameters to test, since if I pass
> `fsck` some random/btrfsck switches:
> 
>   # fsck --repair /dev/storage/lv_btrfs
> 
> I get an error back from `fsck.ext4`:
> 
>   fsck from util-linux 2.20.1
>   fsck.ext4: invalid option -- 'e'

2 things; from the fsck manpage:

       fsck [-sAVRTMNP] [-C [fd]] [-t fstype] [filesys...]  [--] [fs-specific-options]

so I think you need:

fsck -- --repair /dev/storage/lv_btrfs

But the other issues seems to be that fsck & blkid are autodetecting
the device as ext4, not btrfs; a separate issue.

-Eric


