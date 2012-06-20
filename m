Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FTGbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 02:31:12 -0400
Received: by dady13 with SMTP id y13so9412417dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 23:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE141DB.1080308@zytor.com>
References: <20120619234919.GA4102@shiny>
	<CBFTB8kPCXB@helmut.hullen.de>
	<CAE5mzvitiXX9N=qjM=xRgqhHQ9kY6WHXa4jWKGs6xRNOtd7uEA@mail.gmail.com>
	<4FE141DB.1080308@zytor.com>
Date: Wed, 20 Jun 2012 13:31:11 +0700
Message-ID: <CAG1y0sd6RcFwdUN1tMvpSUA0UyX0N0Q32DvFE-jN9ktL9pr4Dg@mail.gmail.com>
Subject: Re: Subvolumes and /proc/self/mountinfo
From: "Fajar A. Nugraha" <list@fajar.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 10:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> a. Make a snapshot of the current root;
> b. Mount said snapshot;
> c. Install the new distro on the snapshot;
> d. Change the bootloader configuration *inside* the snapshot to point
>   to the snapshot as the root;
> e. Install the bootloader on the snapshot, thereby making the boot
>   block point to it and making it "live".


IMHO a more elegant solution would be similar to what
(open)solaris/indiana does: make the boot parts (bootloader,
configuration) as a separate area, separate from root snapshots. In
solaris case IIRC this is will br /rpool/grub.

A similar approach should be implementable in linux, at least on
certain configurations, since if you put /boot as part of "/" (thus,
also on btrfs), AND you don't change the default subvolume, AND the
roots are on their own subvolume, the paths to vmlinuz and initrd on
grub.cfg will have subvols name in it. So it's possible to have a
single grub.cfg having several entries that points to different
subvols. So you don't need to install a new bootloader to make a
particular subvol live, you only need to select it from the boot menu.

I'm doing this currently with ubuntu precise, but with
manually-created grub.cfg though. Still haven't found a way to manage
this automatically.

-- 
Fajar
