Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3IMM6T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:19 -0400
Date: Fri, 13 Sep 2013 14:58:14 +0200
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandra.seetharaman@us.ibm.com, alexander.karbstein@gmail.com
Subject: Re: [PATCH] btrfs-progs: btrfs.8.in: Add info about reverting back
 to root subvolume.
Message-ID: <20130913125814.GI6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2061327.l3bBKU3J9X@localhost.localdomain>
 <20130912132952.GB6810@twin.jikos.cz>
 <4614565.o0AhkXtA95@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4614565.o0AhkXtA95@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 11:02:10AM +0530, chandan wrote:
> On Thursday, September 12, 2013 03:29:52 PM David Sterba wrote:
> > The number 5 is an implementation detail, we should recommend to use 0.
> >
> In the current btrfs kernel code if 0 is passed as the subvolume id,
> the btrfs_ioctl_default_subvol() function sets the subvolume id to the
> objectid of the current subvolume.

Uh, that's right.

> The patch provided at
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg17973.html
> should fix the issue.

I think this is the intended behaviour, 'set-default 0' should set the
toplevel subvolume (ie id 5), the same way as the mount option
'subvolid'. I see that Alex came to the same conclusion in
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg17952.html

But, this should be fixed in kernel, so any tool that uses the ioctl
directly gets the same result.

david
