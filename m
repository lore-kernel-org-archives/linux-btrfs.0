Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43437 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2GESdo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 14:33:44 -0400
Received: by wibhq12 with SMTP id hq12so345712wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 11:33:42 -0700 (PDT)
Date: Thu, 5 Jul 2012 21:33:43 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Zach Brown <zab@zabbo.net>
Cc: Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
Message-ID: <20120705183343.GA5403@zambezi.lan>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
 <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
 <4FF5C9F2.903@zabbo.net>
 <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
 <4FF5CCD0.5000107@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF5CCD0.5000107@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2012 at 10:20:16AM -0700, Zach Brown wrote:
> On 07/05/2012 10:14 AM, Alexander Block wrote:
> >On Thu, Jul 5, 2012 at 7:08 PM, Zach Brown<zab@zabbo.net>  wrote:
> >>
> >>Careful, timespec will be different sizes in 32bit userspace and a 64bit
> >>kernel.  I'd use btrfs_timespec to get a fixed size timespec and avoid
> >>all the compat_timespec noise.  (I'd then also worry about padding and
> >>might pack the struct.. I always lose track of the best practice across
> >>all archs.)
> 
> >Hmm we currently don't have ctree.h in ioctl.h. Can I include it there
> >or are there problems with that? As an alternative I could define my
> >own struct for that.
> 
> Hmm, yeah, it looks like ioctl.h is well isolated and doesn't really
> have a precedent for pulling in format bits from the kernel
> implementation.
> 
> I'd do as you suggested and just make its own ioctl_timespec with a
> comment that its duplicating other similar structures to keep ioctl.h
> from getting tangled up in the kernel-side includes.

This has been done for restriper, see struct btrfs_balance_args vs
struct btrfs_disk_balance_args.  You could do the same thing:

struct btrfs_ioctl_timespec {
	__u64 sec;
	__u32 nsec;
} __attribute__ ((__packed__));

and take endianess into account with le{64,32}_to_cpu and
cpu_to_le{64,32} macros.

Thanks,

		Ilya
