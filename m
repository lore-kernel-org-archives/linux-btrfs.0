Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42811 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKHTrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Nov 2014 14:47:24 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so4692423lbj.9
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 11:47:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141107181628.GE25615@twin.jikos.cz>
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	<1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	<20141107181628.GE25615@twin.jikos.cz>
Date: Sat, 8 Nov 2014 19:47:22 +0000
Message-ID: <CAMU1PDjN0Q4Q=0kzrgjAKCmMdtMGBg-iMTONqQY3m0LuKDzJaA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: fix wrong num_devices for btrfs fi show
 with seed devices
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: David Sterba <dsterba@suse.cz>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 November 2014 18:16, David Sterba <dsterba@suse.cz> wrote:
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

Is find_max_device_id a suitable name?

>> +int correct_fs_info(int fd, struct btrfs_ioctl_fs_info_args *fi_args)
>
> Same here, make fs_info correct but in what way? A comment would be good
> as well.

Sorry, no suggestion for this function name.

Thanks,
Mike
