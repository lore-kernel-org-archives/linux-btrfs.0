Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:40805 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbbGOV3k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 17:29:40 -0400
Received: by vnbg1 with SMTP id g1so5998390vnb.7
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 14:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150715161546.GR10539@carfax.org.uk>
References: <55A4F74D.9000305@gmail.com>
	<55A50DBF.1080602@gmail.com>
	<CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
	<55A63F03.2080207@gmail.com>
	<CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>
	<20150715161546.GR10539@carfax.org.uk>
Date: Wed, 15 Jul 2015 15:29:39 -0600
Message-ID: <CAJCQCtQFBjbuBHXfZ831YAKQwNDh+kxugFE_iMW6VyRzSpio2Q@mail.gmail.com>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 10:15 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>    There is at least one superblock on every device, usually two, and
> often three. Each superblock contains the virtual address of the roots
> of the root tree, the chunk tree and the log tree. Those are useless
> without having the chunk tree, so there's also some information about
> the chunk tree appended to the end of each superblock to bootstrap the
> virtual address space lookup.

So maybe Austin can use btrfs-show-super -a on every device and see if
there's anything different on some of the devices, that shouldn't be
different? There must be something the kernel is tripping over that
the use space tools aren't for some reason.




-- 
Chris Murphy
