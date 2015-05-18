Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36278 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbEROYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 10:24:39 -0400
Received: by iepj10 with SMTP id j10so23461893iep.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 07:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
Date: Mon, 18 May 2015 08:24:39 -0600
Message-ID: <CAJCQCtTedu8HXqCbW-S-JV1euvZA3i404RYPP15Ym-Y6boRdtQ@mail.gmail.com>
Subject: Re: Btrfs and integration with GNU ++
From: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 18, 2015 at 3:22 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

>
> I didn't run it. Some part of the Jessie startup did, and 1 minute for just 6x8GB (not TB) seems a lot…

Systemd issues a generic fsck for root fs, always, even for file
systems that don't have unattended fsck like XFS and btrfs.
Effectively the fs_passno field in fstab is ignored for root fs now.
In order to know what passno is set to required mounting root ro
first, and then executing fsck on an ro filesystem which even ext4
considers dangerous. The fsck.xfs and fsck.btrfs don't really do
anything, if you read their man page you'll see that, but I think they
require all devices present for the fsck to return 0 and systemd to
continue with boot. So I'll bet that for some reason there's a delay
with the devices themselves, or with them all being discovered (by
udev?) and thus the systemd unit for root fs is hanging.

If you're experiencing this 1 minute fsck on a non-root fs btrfs, then
that's a bug. There should be no fsck for btrfs, not even the faux
one. I'd check to make sure fs_passno is set to 0. If not, then I'd
look to the initramfs asking for the unnecessary fsck.


-- 
Chris Murphy
