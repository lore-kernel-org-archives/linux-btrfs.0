Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54240 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbbD0R5W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 13:57:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YmnHO-0005ln-TB
	for linux-btrfs@vger.kernel.org; Mon, 27 Apr 2015 19:57:15 +0200
Received: from abts-kk-dynamic-51.111.171.122-airtelbroadband.in ([abts-kk-dynamic-51.111.171.122-airtelbroadband.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 19:57:14 +0200
Received: from toyours_sridhar by abts-kk-dynamic-51.111.171.122-airtelbroadband.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 19:57:14 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: btrfs freeze/thaw when using with LVM2
Date: Mon, 27 Apr 2015 17:56:58 +0000 (UTC)
Message-ID: <loom.20150427T195047-500@post.gmane.org>
References: <loom.20150427T140306-446@post.gmane.org> <20150427121521.GB18187@carfax.org.uk> <loom.20150427T163556-13@post.gmane.org> <20150427145549.GC18187@carfax.org.uk> <20150427223442.47e254c4@natsu> <20150427173717.GD18187@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

> 
> On Mon, Apr 27, 2015 at 10:34:42PM +0500, Roman Mamedov wrote:
> > On Mon, 27 Apr 2015 14:55:49 +0000
> > Hugo Mills <hugo <at> carfax.org.uk> wrote:
> > 
> > > > This is strange considering that I wanted a consistent snapshot 
of 
> > > > entire btrfs filesystem at volume level.
> > > > 
> > > > Is there a way to achive this? or btrfs just cannot provide?
> > > 
> > >    No, there's no way to manage it with the current btrfs code.
> > 
> > Why not. fsfreeze, dd to a file (optionally with compression), 
unfreeze.
> 
>    OK, point taken, but if you want to use the frozen volume to make a
> file-level backup of the FS contents, you've still got to turn it into
> a block device and mount it... at which point, you get hit by the
> explosion again...
> 
>    Hugo.
> 


If I am not wrong, chunk tree represents the allocaiton block of entire 
file system. I could copy and replicate ( which will be less time 
consume) on alternate disk(s). 

For this kind of backup, either lvm level consistency or freeze/thaw 
would help.

