Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14339 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082AbcGONVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 09:21:21 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5:
 take two
To: Andrei Borzenkov <arvidjaar@gmail.com>, <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <a0538df6-7e25-fae8-8ebd-b18120a1c516@fb.com> <578868EE.2030108@gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <2af4a9cc-bf09-680c-1743-530e521677b2@fb.com>
Date: Fri, 15 Jul 2016 09:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <578868EE.2030108@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/15/2016 12:39 AM, Andrei Borzenkov wrote:
> 15.07.2016 00:20, Chris Mason пишет:
>>
>>
>> On 07/12/2016 05:50 PM, Goffredo Baroncelli wrote:
>>> Hi All,
>>>
>>> I developed a new btrfs command "btrfs insp phy"[1] to further
>>> investigate this bug [2]. Using "btrfs insp phy" I developed a script
>>> to trigger the bug. The bug is not always triggered, but most of time
>>> yes.
>>>
>>> Basically the script create a raid5 filesystem (using three
>>> loop-device on three file called disk[123].img); on this filesystem
>
> Are those devices themselves on btrfs? Just to avoid any sort of
> possible side effects?
>
>>> it is create a file. Then using "btrfs insp phy", the physical
>>> placement of the data on the device are computed.
>>>
>>> First the script checks that the data are the right one (for data1,
>>> data2 and parity), then it corrupt the data:
>>>
>>> test1: the parity is corrupted, then scrub is ran. Then the (data1,
>>> data2, parity) data on the disk are checked. This test goes fine all
>>> the times
>>>
>>> test2: data2 is corrupted, then scrub is ran. Then the (data1, data2,
>>> parity) data on the disk are checked. This test fail most of the time:
>>> the data on the disk is not correct; the parity is wrong. Scrub
>>> sometime reports "WARNING: errors detected during scrubbing,
>>> corrected" and sometime reports "ERROR: there are uncorrectable
>>> errors". But this seems unrelated to the fact that the data is
>>> corrupetd or not
>>> test3: like test2, but data1 is corrupted. The result are the same as
>>> above.
>>>
>>>
>>> test4: data2 is corrupted, the the file is read. The system doesn't
>>> return error (the data seems to be fine); but the data2 on the disk is
>>> still corrupted.
>>>
>>>
>>> Note: data1, data2, parity are the disk-element of the raid5 stripe-
>>>
>>> Conclusion:
>>>
>>> most of the time, it seems that btrfs-raid5 is not capable to rebuild
>>> parity and data. Worse the message returned by scrub is incoherent by
>>> the status on the disk. The tests didn't fail every time; this
>>> complicate the diagnosis. However my script fails most of the time.
>>
>> Interesting, thanks for taking the time to write this up.  Is the
>> failure specific to scrub?  Or is parity rebuild in general also failing
>> in this case?
>>
>
> How do you rebuild parity without scrub as long as all devices appear to
> be present?

If one block is corrupted, the crcs will fail and the kernel will 
rebuild parity when you read the file.  You can also use balance instead 
of scrub.

-chris
