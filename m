Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:58467 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2KFWsh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 17:48:37 -0500
Date: Tue, 6 Nov 2012 14:48:36 -0800
From: Zach Brown <zab@zabbo.net>
To: Hugo Mills <hugo@carfax.org.uk>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Bart Noordervliet <bart@noordervliet.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
Message-ID: <20121106224836.GQ31248@lenny.home.zabbo.net>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
 <CAGy7UtjR+kZoBYWaeg=-jHbJHQh4pe3Jt5cwX-rTQEBHFkQ-YQ@mail.gmail.com>
 <50995DAB.6070103@giantdisaster.de>
 <20121106192054.GC29581@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121106192054.GC29581@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Yes, this happens on 32 bit builds, not on 64 bit builds. If you
> > look at the source code, the compiler is obviously wrong (or I am
> > blind).
> > 
> >         ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
> >                                             args->start.srcdev_name,
> >                                             &src_device);
> >         mutex_unlock(&fs_info->volume_mutex);
> >         if (ret) {  <-- this is line 344
> > 
> > But thanks for the feedback anyway!
> 
>    This usually means that somewhere in the call tree under
> btrfs_dev_replace_find_srcdev(), there's a way that the function can
> return without returning a value

Indeed, and that's obviously the case in 15/26 with
btrfs_dev_replace_find_srcdev() when btrfs_find_device() returns a
device.

*mumbles something about the reason for ERR_PTR semantics*

- z
