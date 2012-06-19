Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60780 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab2FSXvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 19:51:32 -0400
Date: Tue, 19 Jun 2012 19:51:29 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Device names
Message-ID: <20120619235129.GB4102@shiny>
References: <4FDFC807.2080209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FDFC807.2080209@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2012 at 06:29:59PM -0600, H. Peter Anvin wrote:
> I just found out that all the device handling in btrfs is based on
> pathnames, but shorter pathnames (1024) that PATH_MAX (4096).
> 
> This is confusing, and concerning for multiple reasons:
> 
> 1. pathnames are namespace-specific; what is a pathname in one namespace
> might not be in another.
> 2. different truncation rules in the rest of the kernel.
> 
> There seem to be no way one can do the equivalent of BTRFS_IOC_DEV_INFO
> but actually get a device number or other stable information for that
> device (that could be compared to a file descriptor for verification);
> is that an accurate observation?

At mount time, we go through and verify the path names still belong to
the filesystem you thought they belonged to.  The bdev is locked during
the verification, so it won't be able to go away or change.

This is a long way of saying right we don't spit out device numbers.
Even device numbers can change.  We can easily add a uuid based listing,
which I think is what you want.

-chris

