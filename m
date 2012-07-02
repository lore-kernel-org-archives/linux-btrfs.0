Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2GBBaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jul 2012 21:30:03 -0400
Message-ID: <4FF0FBE1.4000303@cn.fujitsu.com>
Date: Mon, 02 Jul 2012 09:39:45 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs-progs: make get default report correctly
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com> <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com> <20120629103643.GB1877@zambezi.lan>
In-Reply-To: <20120629103643.GB1877@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2012 06:36 PM, Ilya Dryomov wrote:

> On Fri, Jun 29, 2012 at 06:00:37PM +0800, Liu Bo wrote:
>> We have both set-default and get-default, but actually our get-default
>> does not show which one is the default one.
>>
>> This patch plus the kernel side patch fix this.
> 
> Are you referring to the fact that get-default in Chris' btrfs-progs
> master lists all subvolumes instead of showing the default one?  If so,
> I fixed that problem a while ago, patch is in Hugo's integration branch.
> 


So can you please show me a link about your patch?

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


