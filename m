Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57104 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2FTAAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 20:00:19 -0400
Message-ID: <4FE1128B.5080004@zytor.com>
Date: Tue, 19 Jun 2012 17:00:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Device names
References: <4FDFC807.2080209@zytor.com> <20120619235129.GB4102@shiny>
In-Reply-To: <20120619235129.GB4102@shiny>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2012 04:51 PM, Chris Mason wrote:
> 
> At mount time, we go through and verify the path names still belong to
> the filesystem you thought they belonged to.  The bdev is locked during
> the verification, so it won't be able to go away or change.
> 
> This is a long way of saying right we don't spit out device numbers.
> Even device numbers can change.  We can easily add a uuid based listing,
> which I think is what you want.
> 

No, I want to find the actual devices.  I know I can get the UUID, but
scanning all the block devices in the system looking for that UUID is a
nonstarter.

Device path names can change while the system is operating (and, worse,
are dependent on namespace changes and chroot); device *numbers* cannot
as long as the device is in use (e.g. mounted.)  They can indeed change
while not in use, of course.

	-hpa
