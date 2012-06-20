Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:38627 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2FTNh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 09:37:57 -0400
Date: Wed, 20 Jun 2012 09:37:54 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Device names
Message-ID: <20120620133754.GE4102@shiny>
References: <4FDFC807.2080209@zytor.com>
 <20120619235129.GB4102@shiny>
 <4FE1128B.5080004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE1128B.5080004@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2012 at 06:00:11PM -0600, H. Peter Anvin wrote:
> On 06/19/2012 04:51 PM, Chris Mason wrote:
> > 
> > At mount time, we go through and verify the path names still belong to
> > the filesystem you thought they belonged to.  The bdev is locked during
> > the verification, so it won't be able to go away or change.
> > 
> > This is a long way of saying right we don't spit out device numbers.
> > Even device numbers can change.  We can easily add a uuid based listing,
> > which I think is what you want.
> > 
> 
> No, I want to find the actual devices.  I know I can get the UUID, but
> scanning all the block devices in the system looking for that UUID is a
> nonstarter.
> 
> Device path names can change while the system is operating (and, worse,
> are dependent on namespace changes and chroot); device *numbers* cannot
> as long as the device is in use (e.g. mounted.)  They can indeed change
> while not in use, of course.

Ok, my two choices for exporting this to you are a /sys/btrfs kind of
directory (representing the mounted filesystems) or an ioctl.  Which one
is most usable for you?

You want to map from /some_dir to a definitive list of devices you need
to find in syslinux to later boot off that FS, right?

-chris
