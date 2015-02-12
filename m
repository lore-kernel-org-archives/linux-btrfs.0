Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbBLHXb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:23:31 -0500
Message-ID: <54DC54ED.5070605@oracle.com>
Date: Thu, 12 Feb 2015 15:23:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/24 V2] provide frame work so that sysfs attributs from
 the fs_devices can be added
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com> <20150211190101.GN28877@twin.jikos.cz>
In-Reply-To: <20150211190101.GN28877@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for commenting. V3 is out. more below.

On 02/12/2015 03:01 AM, David Sterba wrote:
> On Mon, Feb 09, 2015 at 07:56:01AM +0800, Anand Jain wrote:
>> This patch set will provide a framework and help to create attributes
>> from the structure btrfs_fs_devices which are available even before
>> fs_info is created. So by moving the parent kobject super_kobj from
>> fs_info to btrfs_fs_devices, it will help to create attributes
>> from the btrfs_fs_devices as well.
>>
>> Just to note, this does not change any of the existing btrfs sysfs
>> external kobject names and its attributes and not even the life
>> cycle of them. Changes are internal only. And to ensure the same,
>> this path has been tested with various device operations and,
>> checking and comparing the sysfs kobjects and attributes with
>> sysfs kobject and attributes with out this patch, and they remain
>> same. These test cases are added to the progs as test-btrfs-devmgt.sh,
>> its patch is below as well.
>
> I went through the patchset, looks ok to me in general. The only concern
> is about the new seeding representation, but the other changes seem ok
> (but I did not do in-depth review).
>
> I like the patch separation, that really helps to understand the changes
> although there are 20+ patches in total.
>
> We can merge patches 1-22, patch 23 should be folded into 24 as it fixes
> a bug introduced there.

Actually there isn't bug, 24 it provides framework for the upcoming RFC 
patch which is under test. Since I wanted this upcoming RFC patch to be 
sleek, so I pushed 24 with the framework patch set.


Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
