Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030220Ab3HIG5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 02:57:45 -0400
Message-ID: <5204928F.1020603@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 14:56:15 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup destroy -> ERROR: unable to create quota group:
 Device or resource busy
References: <20130809133933.2fbfc6e4@virtall.com> <52048483.1010809@cn.fujitsu.com> <20130809140750.59832bc4@virtall.com> <52048770.40602@cn.fujitsu.com> <20130809144221.740d57b1@virtall.com>
In-Reply-To: <20130809144221.740d57b1@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2013 02:42 PM, Tomasz Chmielewski wrote:
> On Fri, 09 Aug 2013 14:08:48 +0800
> Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
> 
>>> 0/4494 839516160 18446744073709481984 ---   <------ want to remove
>>> only this one
>>>
>>> 13/1 2142674944 2142674944
>>> 0/3973,0/3974,0/3978,0/3981,0/4355,0/4373,0/4398,0/4400,0/4401,0/4427,0/4448,0/4449,0/4457,0/4458,0/4475,0/4476,0/4487,0/4488,0/4489,0/4490,0/4491,0/4492,0/4493,0/4494,0/4495,0/4496,0/4497,0/4498,0/4499,0/4506,0/4507,0/4518
>>>
>>>
>>> Parent qgroup 13/1 makes accounting for other qgroups - therefore,
>>> I don't want to remove it.
>>
>> Sorry, you must destroy relation between 13/1 and 4494. then you can
>> remove it.
> 
> So how exactly should I do it? A bit confused on how to proceed.

btrfs qgroup remove 4494 13/1 <mnt>

will destroy relation between 4494 and 13/1
Then you can try:

btrfs qgroup destroy 4494 <mnt>

Thanks,
Wang
> 
> - remove 13/1, remove 4494
> 
> - add 13/1, and add all previous qgroups to it?
> 0/3973,0/3974,0/3978,0/3981,0/4355,0/4373,0/4398,0/4400,0/4401,....
> 
> - run quota scan?
> 
> 
> It can't be right, can it?
> 
> 

