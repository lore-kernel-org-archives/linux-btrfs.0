Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:60687 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbcGOQaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 12:30:12 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5:
 take two
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <a0538df6-7e25-fae8-8ebd-b18120a1c516@fb.com> <578868EE.2030108@gmail.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <07f69a3b-6adb-118f-ee65-99c73529ee51@inwind.it>
Date: Fri, 15 Jul 2016 18:30:10 +0200
MIME-Version: 1.0
In-Reply-To: <578868EE.2030108@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-15 06:39, Andrei Borzenkov wrote:
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

Good question. However the files are stored on a ext4 filesystem (but I don't 
know if this is better or worse)

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

I corrupted the data, then I read the file. The data has to be correct on
the basis of the parity. Even in this case I found problem.

> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
