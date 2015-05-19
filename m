Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49716 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbbESHZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 03:25:17 -0400
In-Reply-To: <CAJCQCtTedu8HXqCbW-S-JV1euvZA3i404RYPP15Ym-Y6boRdtQ@mail.gmail.com>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net> <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net> <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net> <CAJCQCtTedu8HXqCbW-S-JV1euvZA3i404RYPP15Ym-Y6boRdtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Btrfs and integration with GNU ++
From: Russell Coker <russell@coker.com.au>
Date: Tue, 19 May 2015 17:24:33 +1000
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6079A80F-4A26-4D34-AF20-C3161E895FB0@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you have a reference for fsck on a ro mounted ext4 filesystem being dangerous? The standard behavior of Linux systems has been to fsck a ro mounted ext* root filesystem since long before an initrd was invented.

On May 19, 2015 12:24:39 AM GMT+10:00, Chris Murphy <lists@colorremedies.com> wrote:
>On Mon, May 18, 2015 at 3:22 AM, Roy Sigurd Karlsbakk
><roy@karlsbakk.net> wrote:
>
>>
>> I didn't run it. Some part of the Jessie startup did, and 1 minute
>for just 6x8GB (not TB) seems a lot…
>
>Systemd issues a generic fsck for root fs, always, even for file
>systems that don't have unattended fsck like XFS and btrfs.
>Effectively the fs_passno field in fstab is ignored for root fs now.
>In order to know what passno is set to required mounting root ro
>first, and then executing fsck on an ro filesystem which even ext4
>considers dangerous. The fsck.xfs and fsck.btrfs don't really do
>anything, if you read their man page you'll see that, but I think they
>require all devices present for the fsck to return 0 and systemd to
>continue with boot. So I'll bet that for some reason there's a delay
>with the devices themselves, or with them all being discovered (by
>udev?) and thus the systemd unit for root fs is hanging.
>
>If you're experiencing this 1 minute fsck on a non-root fs btrfs, then
>that's a bug. There should be no fsck for btrfs, not even the faux
>one. I'd check to make sure fs_passno is set to 0. If not, then I'd
>look to the initramfs asking for the unnecessary fsck.

-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
