Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKHBDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 20:03:25 -0500
Message-ID: <545D6BC8.4030403@oracle.com>
Date: Sat, 08 Nov 2014 09:03:04 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: fix wrong num_devices for btrfs fi show
 with seed devices
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com> <20141107181628.GE25615@twin.jikos.cz>
In-Reply-To: <20141107181628.GE25615@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


really nice fix. Thanks Gui.
Anand


On 08/11/2014 02:16, David Sterba wrote:
> On Fri, Nov 07, 2014 at 10:07:43AM +0800, Gui Hecheng wrote:
>> The @fi_args->num_devices in @get_fs_info() does not include seed devices.
>> We could just correct it by searching the chunk tree and count how
>> many dev_items there are in total which includes seed devices.
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> ---
>> *Note*
>> This is just a temporary workaround to fix this problem in order to
>> make users happy, because a new ioctl or sysfs interface to handle this
>> problem needs more discussions and efforts. After the work implemented
>> and accepted, we could drop this.
>
> Nice, thanks. I agree that this kind of workaround is best possible for
> the moment, and I'm glad to see that it's not that much code to get the
> seeding devices right. This would also work with older kernels without
> the updated sysfs/ioctl interfaces, so this is likely to stay for a long
> time.
>
>> +u64 find_max_id(struct btrfs_ioctl_search_args *search_args, int nr_items)
>
> That's a very generic name for a function that does a very specialized
> thing, but I don't have a suggestion right now.
>
>> +int correct_fs_info(int fd, struct btrfs_ioctl_fs_info_args *fi_args)
>
> Same here, make fs_info correct but in what way? A comment would be good
> as well.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
