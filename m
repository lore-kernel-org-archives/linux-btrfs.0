Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45998 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729214AbeGNAma (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 20:42:30 -0400
Date: Sat, 14 Jul 2018 08:25:26 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Filipe Manana <fdmanana@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: About hung task on generic/041
Message-ID: <20180714002526.GD575@fnst.localdomain>
References: <20180711090220.GA21770@fnst.localdomain>
 <CAL3q7H7j+9T1sFV1wd+pw3cd3K9OaBOMc+mqvq7e+guFbVyAdg@mail.gmail.com>
 <20180712123359.GA575@fnst.localdomain>
 <20180713084449.GB575@fnst.localdomain>
 <CAL3q7H4f7Ui-KRFfTuPJyey2OPKC2NFYwuUN9Lxn3cRKd0QVDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAL3q7H4f7Ui-KRFfTuPJyey2OPKC2NFYwuUN9Lxn3cRKd0QVDg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 11:33:39AM +0100, Filipe Manana wrote:
>On Fri, Jul 13, 2018 at 9:44 AM, Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>> On Thu, Jul 12, 2018 at 08:33:59PM +0800, Lu Fengqi wrote:
>>>On Thu, Jul 12, 2018 at 11:40:54AM +0100, Filipe Manana wrote:
>>>>On Wed, Jul 11, 2018 at 10:02 AM, Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>>>>> Hi,
>>>>>
>>>>> When I run generic/041 with v4.18-rc3 (turn on kasan and hung task
>>>>> detection), btrfs-transaction kthread will trigger the hung task timeout
>>>>> (stall at wait_event in btrfs_commit_transaction). At the same time, you
>>>>> can see that xfs_io -c fsync will occupy 100% of the CPU. I am not sure
>>>>> whether this is a problem. Any suggestion?
>>>>
>>>>Well, something at 100% cpu and that seems hang forever is definitely
>>>>a problem, specially a workload as simple as the one in generic/041
>>>
>>>To clarify, the hung task will end within 500s. Without KASAN, it will
>>>end within 80s, so it won't trigger hung task timeout 120s. I'm not sure
>>>if this is just slow, or have some problem?
>>
>> Well, I tried to run generic/041 with v4.18-rc4(with KASAN) on the other
>> machine(with HDD) and it didn't finish all night. The hung task maybe
>> only end within 500s on SSD.
>>
>>>
>>>>(never happened to me, even on vanilla 4.18-rc4).
>>
>> See the attachment kernel_config. Maybe some config make you can't
>> replicate the case.
>
>Don't have to look into that, but I'm attaching mine and then you can
>compare them.

You must set the following config. As mentioned above, the test won't hit
the hung task timeout without *KASAN*.

CONFIG_KASAN=y
CONFIG_KASAN_EXTRA=y
CONFIG_KASAN_OUTLINE=y

>
>>
>>>>Do you have the stack trace for the fsync task? What you pasted below
>>>
>>>I will send the stack trace tomorrow.
>>
>> See the attachment kasan.log.xz.
>>
>> From the log it seems that the time is consumed in the
>> btrfs_log_inode_parent loop call btrfs_log_inode.
>>
>> I'm very willing to provide a trace(without KASAN) for comparison, but when
>> I run both systemtap and testcase, I have another problem.
>>
>> See the attachment btrfs_sync_file.stp and 4.18-rc4.dmesg.
>
>Are you sure you running a vanilla kernel, without any other btrfs patches?
>This test case has been around since 2015 and no one ever run into
>such problem (it takes around 15 seconds to finish here, on 2 vms with
>a debug kernel).
>
>Does that happen to you on 4.17 or older kernels too? If it doesn't,
>then I suggest bisecting.

As soon as I turn on KASAN, the test case will encounter this problem at
the vanilla 4.17/4.18-rc3/4.18-rc4 kernel(no other patches).

-- 
Thanks,
Lu

>
>>
>> --
>> Thanks,
>> Lu
>>
>>>
>>>--
>>>Thanks,
>>>Lu
>>>
>>>>is only for the transaction kthread and that alone doesn't help.
>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>>--
>>>>Filipe David Manana,
>>>>
>>>>“Whether you think you can, or you think you can't — you're right.”
>>>>
>>>>
>>
>>
>
>
>
>-- 
>Filipe David Manana,
>
>“Whether you think you can, or you think you can't — you're right.”
>
>


