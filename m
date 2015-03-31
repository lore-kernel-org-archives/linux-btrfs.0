Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:7002 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbbCaJjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 05:39:55 -0400
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com [209.85.223.181])
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 5857A68D2FD
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 17:39:45 +0800 (CST)
Received: by iebmp1 with SMTP id mp1so3934284ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 02:39:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5ujYoDoo66OY5HAgpQF-i5CyyinMphHVwZmt=ieAKURg@mail.gmail.com>
References: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
	<CAL3q7H5ujYoDoo66OY5HAgpQF-i5CyyinMphHVwZmt=ieAKURg@mail.gmail.com>
Date: Tue, 31 Mar 2015 17:39:51 +0800
Message-ID: <CAJiZgcoN11adj+8hNDSZ=PwcHjc+ty9ftsMM0gJrQ6CW7Z18Lg@mail.gmail.com>
Subject: Re: Btrfs Send/Receive "utime" error And "WARN_ON Cannot allocate memory"
From: Robbie Ko <robbieko@synology.com>
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,

After taking a look at design of send/receive, I feel that severe
directory structure movement combined with name collision might be a
trouble maker for send to calculate the snapshot difference.
Therefore, I started using fsstress + random directory movement to
test. Since the diff commands might contain a lot of instructions, I
try to simplify them before reporting.

Thanks for your help.

Thanks.
robbieko

2015-03-31 16:40 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
> On Tue, Mar 31, 2015 at 4:06 AM, Robbie Ko <robbieko@synology.com> wrote:
>> Hi,
>>
>> I have  testing btrfs send/receive recently.
>>
>> I got an error "send ioctl failed with -12: Cannot allocate memory" on
>> send side.
>> WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.
>>
>> I got an error "utime failed: No such file or directory" on receive side.
>> The followings are simple reproduced steps and related information.
>>
>> I have applied the following patch in the url :
>> https://patchwork.kernel.org/patch/6113581/.
>> However, it did not fix the problem.
>>
>> Is there any  idea about what this might be or how to fix it?
>>
>> Steps to reproduce:
>>
>>   $ mkfs.btrfs -f /dev/sdb
>>   $ mount /dev/sdb /mnt
>>   $ mkfs.btrfs -f /dev/sdc
>>   $ mount /dev/sdc /mnt2
>>
>> $ mkdir -p /mnt/data
>> $ mkdir -p /mnt/data/n1/n2
>> $ mkdir -p /mnt/data/n4
>> $ mkdir -p /mnt/data/t6/t7
>> $ mkdir -p /mnt/data/t5
>> $ mkdir -p /mnt/data/t7
>> $ mkdir -p /mnt/data/n4/t2
>> $ mkdir -p /mnt/data/t4
>> $ mkdir -p /mnt/data/t3
>> $ mv /mnt/data/t7 /mnt/data/n4/t2
>> $ mv /mnt/data/t4 /mnt/data/n4/t2/t7
>> $ mv /mnt/data/t5 /mnt/data/n4/t2/t7/t4
>> $ mv /mnt/data/t6 /mnt/data/n4/t2/t7/t4/t5
>> $ mv /mnt/data/n1/n2 /mnt/data/n4/t2/t7/t4/t5/t6
>> $ mv /mnt/data/n1 /mnt/data/n4/t2/t7/t4/t5/t6
>> $ mv /mnt/data/n4/t2/t7/t4/t5/t6/t7 /mnt/data/n4/t2/t7/t4/t5/t6/n2
>> $ mv /mnt/data/t3 /mnt/data/n4/t2/t7/t4/t5/t6/n2/t7
>>
>>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
>>
>> $ mv /mnt/data/n4/t2/t7/t4/t5/t6/n1 /mnt/data/n4
>> $ mv /mnt/data/n4/t2 /mnt/data/n4/n1
>> $ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6/n2 /mnt/data/n4/n1/t2
>> $ mv /mnt/data/n4/n1/t2/n2/t7/t3 /mnt/data/n4/n1/t2
>> $ mv /mnt/data/n4/n1/t2/t7/t4/t5/t6 /mnt/data/n4/n1/t2
>> $ mv /mnt/data/n4/n1/t2/t7/t4 /mnt/data/n4/n1/t2/t6
>> $ mv /mnt/data/n4/n1/t2/t7 /mnt/data/n4/n1/t2/t3
>> $ mv /mnt/data/n4/n1/t2/n2/t7 /mnt/data/n4/n1/t2
>>
>>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
>>
>>   $ btrfs send /mnt/snap1 | btrfs receive /mnt2
>>   $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive /mnt2
>> ERROR: send ioctl failed with -12: Cannot allocate memory
>> ERROR: utimes data/n4/t2/t7/t4/t5/t6/n2 failed. No such file or directory.
>
>
> Hi,
>
> May I ask if these reproducers come from a real application/workload
> or are they generated through some fuzz tester (like fsstress)?
> It would be easier, and save time, if you mention how to get such
> reproducers instead of sending the same e-mail over and over again but
> with different reproducers.
>
> I'll take a look at it soon.
>
> thanks
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
