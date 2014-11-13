Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42691 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaKMWOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 17:14:47 -0500
Date: Thu, 13 Nov 2014 22:14:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Martin Kepplinger <martink@posteo.de>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't check for file->private_data on open(). It
 is set by the core.
Message-ID: <20141113221441.GL7996@ZenIV.linux.org.uk>
References: <1415810308-24243-1-git-send-email-martink@posteo.de>
 <1415815173.25389.2@mail.thefacebook.com>
 <5463A84A.8010606@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5463A84A.8010606@posteo.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 12, 2014 at 07:34:50PM +0100, Martin Kepplinger wrote:

> > Btrfs uses this in the transaction start ioctl to record the transaction
> > handle being started.  Ceph is the main user of the ioctl, and we could
> > setup a hash table if needed.  But which call path in miscdevice is
> > doing this?
> > 
> > With your patch in place, btrfs would end up overwriting the miscdevice
> > private_data field, which would probably cause problems.
> > 
> > -chris
> > 
> 
> I think i was mistaken, sorry. misc_open() used to set
> file->private_data _only_ if you use set .open in struct file_operations.
> 
> In current -next this changed and file->private_data is set to struct
> miscdevice on a (userspace's) open call (misc_open()) just in any case.
> 
> You do set .open so this wouldn't affect you and this patch can be ignored.

More to the point, this function is not reachable from anything in
file_operations of any miscdevice.  btrfs_ioctl != btrfs_control_ioctl...
