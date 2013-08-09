Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934159Ab3HIGKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 02:10:17 -0400
Message-ID: <52048770.40602@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 14:08:48 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup destroy -> ERROR: unable to create quota group:
 Device or resource busy
References: <20130809133933.2fbfc6e4@virtall.com> <52048483.1010809@cn.fujitsu.com> <20130809140750.59832bc4@virtall.com>
In-Reply-To: <20130809140750.59832bc4@virtall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2013 02:07 PM, Tomasz Chmielewski wrote:
> On Fri, 09 Aug 2013 13:56:19 +0800
> Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
> 
>>> It seems that btrfs automatically assigns a qgroup to newly created
>>> snapshot/subvolume, but does not destroy the qgroup when the
>>> subvolume is deleted.
>>
>> This should be implemented. And will soon.
> 
> Great to hear (using 3.11-rc4 now).
> 
> 
>>> So I've tried to destroy the unused qgroups, with mixed success. I
>>> was able to destroy most of them, but some are still failing, i.e.:
>>>
>>> # btrfs qgroup destroy 4494 /mnt/lxc1
>>> ERROR: unable to create quota group: Device or resource busy
>>
>> Just remove qgroup（4494）'s parent qgroup. then it can be removed.
>> Anyway, i think this is unnecessary.
> 
> I don't want to remove the parent qgroup, as it's in use by other subvolumes:
> 
> # /usr/src/qgroup/btrfs-progs/btrfs qgroup show -c /mnt/lxc1 | grep 4494
> 
> 0/4494 839516160 18446744073709481984 ---   <------ want to remove only this one
> 
> 13/1 2142674944 2142674944 0/3973,0/3974,0/3978,0/3981,0/4355,0/4373,0/4398,0/4400,0/4401,0/4427,0/4448,0/4449,0/4457,0/4458,0/4475,0/4476,0/4487,0/4488,0/4489,0/4490,0/4491,0/4492,0/4493,0/4494,0/4495,0/4496,0/4497,0/4498,0/4499,0/4506,0/4507,0/4518
> 
> 
> Parent qgroup 13/1 makes accounting for other qgroups - therefore, I don't want to remove it.

Sorry, you must destroy relation between 13/1 and 4494. then you can remove it.

thanks,
Wang
> 
> 
> 
> BTW, "/usr/src/qgroup/btrfs-progs/btrfs" is from http://github.com/miaoxie/btrfs-progs.git, to support printing parent/child qgroup IDs.
> 
> Note it shows different values than btrfs from official repository - is that expected?
> 
> # /usr/src/qgroup/btrfs-progs/btrfs qgroup show /mnt/lxc1 | grep 4494
> 0/4494 839516160 18446744073709481984
> 
> # btrfs qgroup show /mnt/lxc1 | grep 4494
> 0/4494 839516160 -69632
> 

