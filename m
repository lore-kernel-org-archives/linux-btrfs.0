Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2GBB57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jul 2012 21:57:59 -0400
Message-ID: <4FF1026E.9080007@cn.fujitsu.com>
Date: Mon, 02 Jul 2012 10:07:42 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: add support to set subvolume/snapshot
 readonly
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com> <20120629102141.GA1877@zambezi.lan>
In-Reply-To: <20120629102141.GA1877@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2012 06:21 PM, Ilya Dryomov wrote:

> On Fri, Jun 29, 2012 at 06:00:36PM +0800, Liu Bo wrote:
>> Setting subvolume/snapshot readonly has been missing for a long time.
>>
>> With this patch, we can set a subvolume/snapshot readonly via:
>>
>> o    btrfs subvolume set-ro <path>
> 
> Alexander's 'btrfs property' patches do exactly this, but in a much more
> generic and extensible way.  'btrfs property' subgroup provides a
> uniform interface for getting and setting properties of filesystem
> objects in general, not only those of subvolumes and snapshots.  It
> provides a much better user interface, and it also allows us to easily
> rethink kernel-user interface for generic get/set in future.
> 


Thanks for the explanation!

But I prefer keeping the current categories {subvolume,filesystem,device,...}:

o Compatibility, we cannot remove the old commands until we make sure that no users will
  use them.

o We've three properties {default, readonly, lable}, is it worthy making another new interface?

o Current categories are clear and clean.


thanks,
liubo

> Thanks,
> 
> 		Ilya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


