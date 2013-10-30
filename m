Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab3J3B6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 21:58:33 -0400
Message-ID: <527066FD.3020309@cn.fujitsu.com>
Date: Wed, 30 Oct 2013 09:55:09 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: memory leak in <=3.11.6
References: <9c53ka-otf.ln1@hurikhan77.spdns.de> <CALJXSJr0sjzFwCT=w1WdDX+-CWS-CjDhYBArVpvTeUNBM88Mdw@mail.gmail.com> <pan$d5444$ef292b25$154f150a$c91a6fe4@cox.net> <CALJXSJoaLrr0gPrMww_MR-5n+_7gmqai1tkvRhwGxNX12weaSA@mail.gmail.com>
In-Reply-To: <CALJXSJoaLrr0gPrMww_MR-5n+_7gmqai1tkvRhwGxNX12weaSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2013 06:46 AM, Jérôme Poulin wrote:
> On Tue, Oct 29, 2013 at 12:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> So I'd call the qgroups feature broken at this time
> I agree. I made a page about Quotas on the wiki so to document my
> findings as documentation is really sparse. If you consult the section
> Known issues, you will find those:
>
> * To get accurate information, you must issue a sync before using the
> qgroup show command.
This is true in some extent.

qgroup accounting info(stored in disk) only update when commting
transaction.

Anyway, by triggering a sync is a little overhead. maybe we can
implement an sync ioctl for quota sync.
> * The qgroup show command is missing some information, for example you
> cannot see which subvolume is part of a parent qgroup.
This has been implemented in the latest chris's integration branch,you 
can use

btrfs qgroup show -p <mnt>
> * Creating a qgroup from an existing directory will show a 0 usage
> until a full filesystem quota rescan is issued
In the latest kernel. if you enable quota, it will create qgroup
for every existed subvolume, and then rescan will be triggered
automatically.(only happens in rescanning)

When creating a subvolume, you can use
btrfs sub create -i <pid> <mnt>

this will add a parent qgroup for a subvolume the moment it was created,
we can avoid rescanning for this case.

However, if you create a parent qgroup and then assign subvolume qgroup
to this parent qgroup online, you have to rescan.
>   
> * Using btrfs subvolume delete will break qgroup unshared space usage.
> * After deleting a subvolume, you must manually delete the associated qgroup.
This is true, for now, deleting a subvolume will cause wrong qgroup 
accounting.
Jan sent a patch for this recently, hopely this problem can be solved as 
soon as
possible.

I have planed to make a patch to drop associated qgroup when deleting a 
subvolume
only if qgroup accounting problem has been fixed.

>
> Knowing this, if you create a qgroup after some files have been added
> to a subvolume, those never get accounted for until you rescan the
> whole volume. This means that if you manage to delete enough "not
> accounted for" files, you get negative numbers.
>
> Wiki: https://btrfs.wiki.kernel.org/index.php/Quota_support
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

