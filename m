Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab2GCBRd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 21:17:33 -0400
Message-ID: <4FF24A7B.3090902@cn.fujitsu.com>
Date: Tue, 03 Jul 2012 09:27:23 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs-progs: make get default report correctly
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com> <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com> <20120629103643.GB1877@zambezi.lan> <4FF0FBE1.4000303@cn.fujitsu.com> <20120702094557.GA2653@zambezi.lan>
In-Reply-To: <20120702094557.GA2653@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2012 05:45 PM, Ilya Dryomov wrote:

> On Mon, Jul 02, 2012 at 09:39:45AM +0800, Liu Bo wrote:
>> On 06/29/2012 06:36 PM, Ilya Dryomov wrote:
>>
>>> On Fri, Jun 29, 2012 at 06:00:37PM +0800, Liu Bo wrote:
>>>> We have both set-default and get-default, but actually our get-default
>>>> does not show which one is the default one.
>>>>
>>>> This patch plus the kernel side patch fix this.
>>> Are you referring to the fact that get-default in Chris' btrfs-progs
>>> master lists all subvolumes instead of showing the default one?  If so,
>>> I fixed that problem a while ago, patch is in Hugo's integration branch.
>>>
>>
>> So can you please show me a link about your patch?
> 
> I'm sorry, it turns out Hugo hasn't pushed it yet.  Here is a link:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/16187/
> 


Fairly good patches.

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


