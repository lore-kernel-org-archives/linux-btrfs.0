From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: how stable are snapshots at the block level?
Date: Tue, 25 Oct 2011 12:01:17 +0000 (UTC)
Message-ID: <slrnjad98d.d1s.stephane.chazelas@spam.is.invalid>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
 <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
 <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
 <000001cc9255$2b34fc70$819ef550$@nedharvey.com>
 <slrnjaavrd.ml8.stephane.chazelas@spam.is.invalid>
 <000501cc930b$cae17bc0$60a47340$@nedharvey.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-25, 07:46(-04), Edward Ned Harvey:
[...]
> My suggestion to the OP of this thread is to use rsync for now, wait for
> btrfs send, or switch to zfs.
[...]

rsync won't work if you've got snapshot volumes though (unless
you're prepared to have a backup copy thousands of times the
size of the original or have a framework in place to replicate
the snapshots on the backup copy as soon as they are created
(but before they're being written to)).

To backup a btrfs FS with snapshots, the only option seems to
be to copy the block devices for now (or the other trick
mentionned earlier).

-- 
Stephane

