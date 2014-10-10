Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaJJHmg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 03:42:36 -0400
Message-ID: <54378F28.5090300@oracle.com>
Date: Fri, 10 Oct 2014 15:47:52 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: force overwrite should wipe stale SB
References: <20141001112606.GO11436@twin.jikos.cz> <1412205729-20938-1-git-send-email-anand.jain@oracle.com> <20141010073949.GE22943@twin.jikos.cz>
In-Reply-To: <20141010073949.GE22943@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks.
Anand

On 10/10/2014 03:39 PM, David Sterba wrote:
> On Thu, Oct 02, 2014 at 07:22:09AM +0800, Anand Jain wrote:
>> (I am unable to reproduce the issue, tried to go back with progs versions
>> but still the same. So as of now this code remains untested, suggest to
>> wait till we have a reproducible test case).
>>
>> Here is a test case which says it all..
>>
>> mkfs.xfs -f $DEV
>> mkfs.btrfs -f $DEV
>> mount $DEV $MNT
>> mount: /dev/vdiskc: more filesystems detected. This should not happen,
>>         use -t <type> to explicitly specify the filesystem type or
>>         use wipefs(8) to clean up the device.
>>
>> mount: you must specify the filesystem type
>>
>> with this patch btrfs_prepare_device() also wipes old FS if any,
>> btrfs_prepare_device() is called after we have verified that
>> user has provided -f option.
>>
>> v2: to satisfy the backward compatibility issue, replace
>> blkid_do_wipe() with local wipe function.
>
> Thank you, works for me, added to 3.17 queue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
