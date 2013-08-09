Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52092 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3HIMr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 08:47:27 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so4570857pbb.13
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 05:47:27 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs qgroup destroy -> ERROR: unable to create quota group: Device or resource busy
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130809140750.59832bc4@virtall.com>
Date: Fri, 9 Aug 2013 20:47:20 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <19E94125-866B-4A13-8227-28CAD070CD91@gmail.com>
References: <20130809133933.2fbfc6e4@virtall.com> <52048483.1010809@cn.fujitsu.com> <20130809140750.59832bc4@virtall.com>
To: Tomasz Chmielewski <tch@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello, just add my answer for a missing question.

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
>> Just remove qgroup£¨4494£©'s parent qgroup. then it can be removed.
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
> 
> 
> 
> BTW, "/usr/src/qgroup/btrfs-progs/btrfs" is from http://github.com/miaoxie/btrfs-progs.git, to support printing parent/child qgroup IDs.
> 
> Note it shows different values than btrfs from official repository - is that expected?
> 
> # /usr/src/qgroup/btrfs-progs/btrfs qgroup show /mnt/lxc1 | grep 4494
> 0/4494 839516160 18446744073709481984

In fact, group's exclusive must be less or equal  than it's referenced  value, if you find it is not true in official
progs, you can report it!

Here should be expected, because, i don't cast qgroup's value to s64 while
it is stored as u64. I will fix this problem when i rebase my patch-set.

In fact, i doubt whether qgroup's exclusive helps, because it always can not
work very well, it requires user to track the value especially snapshoting.

Thanks,
Wang 

> 
> # btrfs qgroup show /mnt/lxc1 | grep 4494
> 0/4494 839516160 -69632
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

