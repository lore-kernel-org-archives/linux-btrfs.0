Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56953 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2FSXgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 19:36:07 -0400
Message-ID: <4FE10CDF.5050102@zytor.com>
Date: Tue, 19 Jun 2012 16:35:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes and /proc/self/mountinfo
References: <4FDFCA43.2070407@zytor.com> <1340115766.3403.19.camel@cwalton-XPS-8300>
In-Reply-To: <1340115766.3403.19.camel@cwalton-XPS-8300>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2012 07:22 AM, Calvin Walton wrote:
> 
> All subvolumes are accessible from the volume mounted when you use -o
> subvolid=0. (Note that 0 is not the real ID of the root volume, it's
> just a shortcut for mounting it.)
> 

Could you clarify this bit?  Specifically, what is the real ID of the
root volume, then?

I found that after having set the default subvolume to something other
than the root, and then mounting it without the -o subvol= option, then
the subvolume name does *not* show in /proc/self/mountinfo; the same
happens if a subvolume is mounted by -o subvolid= rather than -o subvol=.

Is this a bug?  This would seem to give the worst of both worlds in
terms of actually knowing what the underlying filesystem path would end
up looking like.

	-hpa
