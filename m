Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753688AbeBPHkw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 02:40:52 -0500
Subject: Re: Ongoing Btrfs stability issues
To: Alex Adriaanse <alex@oseberg.io>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <83bfc8da-82fd-e2bf-4b27-175bf90ac072@suse.com>
 <2A1FE868-FE3A-489A-B600-8F460D3DFFC8@oseberg.io>
 <17374c30-4376-a96f-ee38-791a95676ae0@suse.com>
 <81FC1059-87DE-49DE-81D0-95C651A5A928@oseberg.io>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <57784be9-55b7-2465-3cfe-c693a55e44f7@suse.com>
Date: Fri, 16 Feb 2018 09:40:49 +0200
MIME-Version: 1.0
In-Reply-To: <81FC1059-87DE-49DE-81D0-95C651A5A928@oseberg.io>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.02.2018 06:54, Alex Adriaanse wrote:
> 
>> On Feb 15, 2018, at 2:42 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>
>> On 15.02.2018 21:41, Alex Adriaanse wrote:
>>>
>>>> On Feb 15, 2018, at 12:00 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>>
>>>> So in all of the cases you are hitting some form of premature enospc.
>>>> There was a fix that landed in 4.15 that should have fixed a rather
>>>> long-standing issue with the way metadata reservations are satisfied,
>>>> namely:
>>>>
>>>> 996478ca9c46 ("btrfs: change how we decide to commit transactions during
>>>> flushing").
>>>>
>>>> That commit was introduced in 4.14.3 stable kernel. Since you are not
>>>> using upstream kernel I'd advise you check whether the respective commit
>>>> is contained in the kernel versions you are using.
>>>>
>>>> Other than that in the reports you mentioned there is one crash in
>>>> __del_reloc_root which looks rather interesting, at the very least it
>>>> shouldn't crash...
>>>
>>> I checked the Debian source code that's used for building the kernels that we run, and can confirm that both 4.14.7-1~bpo9+1 and 4.14.13-1~bpo9+1 contain the changes associated with the commit you referenced. So crash instances #2, #3, and #4 at https://bugzilla.kernel.org/show_bug.cgi?id=198787 were all running kernels that contain this fix already.
>>>
>>> Could it be that some on-disk data structures got (silently) corrupted while we were running pre-4.14.7 kernels, and the aforementioned fix doesn't address anything relating to damage that has already been done? If so, is there a way to detect and/or repair this for existing filesystems other than running a "btrfs check --repair" or rebuilding filesystems (both of which require a significant amount of downtime)?
>>
>> From the logs provided I can see only a single crash, the others are
>> just ENOSPC which can cause corruption due to delayed refs (in majority
>> of examples) not finishing. Is btrfs hosted on the EBS volume or on the
>> ephemeral storage of the instance? Is the EBS an ssd? If it's ssd are
>> you using an io scheduler for those ebs devices? You ca check what the
>> io scheduler for a device is by reading the following sysfs file:
>>
>> /sys/block/<disk device>/queue/scheduler
> 
> It's hosted on an EBS volume; we don't use ephemeral storage at all. The EBS volumes are all SSD. We didn't change the default schedulers on the VMs and it looks like it's using mq-deadline:
> 
> $ cat /sys/block/xvdc/queue/scheduler
> [mq-deadline] none

SO one thing I can advise to test is set the scheduler for that xvdc to
none. Next, I'ad advise you backport the following patch to your kernel:
https://github.com/kdave/btrfs-devel/commit/1b816c23e91f70603c532af52cccf17e68393682

then mount the filesystem with -o enospc_debug. And the next time an
enospc occurs additional info should be printed in dmesg with the state
of the space_info structure.

> 
> Alex--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
