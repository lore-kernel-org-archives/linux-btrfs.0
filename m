Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37098 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbbESSCc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 14:02:32 -0400
Received: by igbsb11 with SMTP id sb11so20616065igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 11:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6079A80F-4A26-4D34-AF20-C3161E895FB0@coker.com.au>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
	<CAJCQCtTedu8HXqCbW-S-JV1euvZA3i404RYPP15Ym-Y6boRdtQ@mail.gmail.com>
	<6079A80F-4A26-4D34-AF20-C3161E895FB0@coker.com.au>
Date: Tue, 19 May 2015 12:02:31 -0600
Message-ID: <CAJCQCtSnM9hjCRGFBawOpEuvsOxyoB6vCwCVP5KFWwVqMD_g5g@mail.gmail.com>
Subject: Re: Btrfs and integration with GNU ++
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 1:24 AM, Russell Coker <russell@coker.com.au> wrote:
> Do you have a reference for fsck on a ro mounted ext4 filesystem being dangerous? The standard behavior of Linux systems has been to fsck a ro mounted ext* root filesystem since long before an initrd was invented.

Actually, slight confusion. XFS has a repair dangerously mode
explicitly for repairing ro mounted XFS file systems. The man page for
e2fsck says it's unsafe to fsck a mounted fs. It doesn't explicitly
distinguish between ro and rw mounts, but from this list I've learned
ro mounts aren't guaranteed to be ro, even if they should be ro. The
e2fsck man page says even if it's safe, it's unreliable.

Anyway, it seems worse to me to have a system where you have to ro
mount a file system that you suspect might be inconsistent so that the
fsck binary can be read and then operated on that same file system.
Ancient madness.

-- 
Chris Murphy
