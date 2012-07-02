Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56901 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2GBKAf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 06:00:35 -0400
Received: by eaak11 with SMTP id k11so2006086eaa.19
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 03:00:34 -0700 (PDT)
Date: Mon, 2 Jul 2012 13:00:27 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: add support to set subvolume/snapshot
 readonly
Message-ID: <20120702100027.GB2653@zambezi.lan>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120629102141.GA1877@zambezi.lan>
 <4FF1026E.9080007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF1026E.9080007@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 10:07:42AM +0800, Liu Bo wrote:
> On 06/29/2012 06:21 PM, Ilya Dryomov wrote:
> 
> > On Fri, Jun 29, 2012 at 06:00:36PM +0800, Liu Bo wrote:
> >> Setting subvolume/snapshot readonly has been missing for a long time.
> >>
> >> With this patch, we can set a subvolume/snapshot readonly via:
> >>
> >> o    btrfs subvolume set-ro <path>
> > 
> > Alexander's 'btrfs property' patches do exactly this, but in a much more
> > generic and extensible way.  'btrfs property' subgroup provides a
> > uniform interface for getting and setting properties of filesystem
> > objects in general, not only those of subvolumes and snapshots.  It
> > provides a much better user interface, and it also allows us to easily
> > rethink kernel-user interface for generic get/set in future.
> > 
> 
> 
> Thanks for the explanation!
> 
> But I prefer keeping the current categories {subvolume,filesystem,device,...}:
> 
> o Compatibility, we cannot remove the old commands until we make sure that no users will
>   use them.

We are not going to remove old commands any time soon.  However, adding
new ones that clearly fall into get/set category, is not a good idea.
Especially when there is a generic interface on its way.

> 
> o We've three properties {default, readonly, lable}, is it worthy making another new interface?

It's not just about subvolumes.  There will be a lot more properties on
the table as filesystem matures, for example device speeds, subvolume
profiles, quotas.

> 
> o Current categories are clear and clean.

Once again, it's not just about subvolumes.  Current categories are
indeed clear, but adding two commands for each non-trivial property that
comes up in future does not seem practical to me.

Thanks,

		Ilya
