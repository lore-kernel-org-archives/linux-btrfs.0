Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36451 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbcDES5J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 14:57:09 -0400
Received: by mail-qg0-f52.google.com with SMTP id f52so18034005qga.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 11:57:09 -0700 (PDT)
Subject: Re: good documentation on btrfs internals and on disk layout
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <loom.20160330T155403-473@post.gmane.org>
 <20160330184327.GO29474@carfax.org.uk>
 <CAKWEGV5tsEJHmb_Y0aQD0fsc4v3Un4rWBzS5QUUGhFz2HyTGKg@mail.gmail.com>
 <570400A4.4090609@gmail.com>
 <CAKWEGV4TTbC4PW=VoxbRxFL0L4DrgrCVNaEca-xroHeQDQe4Rg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57040A51.5060800@gmail.com>
Date: Tue, 5 Apr 2016 14:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKWEGV4TTbC4PW=VoxbRxFL0L4DrgrCVNaEca-xroHeQDQe4Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-05 14:36, Yauhen Kharuzhy wrote:
> 2016-04-05 11:15 GMT-07:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>> On 2016-04-05 13:53, Yauhen Kharuzhy wrote:
>>>
>>> Hello,
>>>
>>> I try to understand btrfs logic in mounting of multi-device filesystem
>>> when device generations are different. All my questions are related to
>>> RAID5/6 for system, metadata, and data case.
>>>
>>> Kernel can mount FS with different device generations (if drive was
>>> physically removed before last unmount and returned back after, for
>>> example) now but scrub will report uncorrectable errors after this
>>> (but second run doesn't show any errors). Does any documentation about
>>> algorithm of multiple device handling in such case exist? Does the
>>> case with different device generations is allowed in general and what
>>> worst cases can be here?
>>
>> In general, it isn't allowed, but we don't explicitly disallow it either.
>> The worst case here is that the devices both get written two separately, and
>> you end up with data not matching for correlated generation ID's.  The
>> second scrub in this case shows no errors because the first one corrects
>> them (even though they are reported as uncorrectable, which is a bug as far
>> as I can tell), and from what I can tell from reading the code, it does this
>> by just picking the highest generation ID and dropping the data from the
>> lower generation.
>
> Hmm... Sounds reasonable but how to detect if filesystem should be
> checked by scrub after mounting? There is one way as I understand — to
> check kernel logs after mount for any btrfs errors and this is not a
> good way for case of some kind of automatic management.
There really isn't any way that I know of.  Personally, I just scrub all 
my filesystems shortly after mount, but I also have pretty small 
filesystems (the biggest are 64G) on relatively fast storage.  In 
theory, it might be possible to parse the filesystems before mounting to 
check the device generation numbers, but that may be just as expensive 
as just scrubbing the filesystem (and you really should be scrubbing 
somewhat regularly anyway).
>
>>> What should happen if device was removed and returned back after some
>>> time when filesystem is online? Should some kind of device
>>> reopening be possible or one possible way to guarantee FS consistensy
>>> is  to mark such device as missing and to replace it?
>>
>> In this case, the device being removed (or some component between the device
>> and the processor failing, or the device itself erroneously reporting
>> failure) will force the FS read-only.  If the device reappears while the FS
>> is still online, it may just start working again (this is _really_ rare, and
>> requires that the device appear with the same device node as it had
>> previously, and this usually only happens when the device disappears for
>> only a very short period of time), or it may not work until the FS gets
>> remounted (this is usually the case), or the system may crash (thankfully
>> this almost never happens, and it's usually not because of BTRFS when it
>> does).  Regardless of what happens, you may still have to run a scrub to
>> make sure everything is consistent.
>
> So, one right way if we see device reconnected as new block device —
> is to reject it and don't include it in device list again, am I right?
> Existing code tries to 'reconnect' it with new device name but this
> works completely wrong for mounted FS (because btrfs device is renamed
> only, no real device reopening is performed) and I intend to propose
> patch based on Anand's 'global spare' patch series to handle this
> properly.
In an ideal situation, you have nothing using the FS and can unmount, 
run a device scan, and then remount.  In most cases this won't work, and 
being able to re-add the device via a hot-spare type setup (or even just 
use device replace on it, which I've done before myself when dealing 
with filesystems on USB devices, and it works well) would be useful. 
Ideally, we should have the option to auto-detect such a situation and 
handle it, but that _really_ needs to be optional (there are just too 
many things that could go wrong).

