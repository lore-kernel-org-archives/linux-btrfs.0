Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46848 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614Ab3AOXcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 18:32:15 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn14so2902837wib.4
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 15:32:13 -0800 (PST)
Message-ID: <50F5E6FA.60803@gmail.com>
Date: Tue, 15 Jan 2013 23:32:10 +0000
From: Tom Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny> <50F422BC.4000901@gmail.com> <20130114155718.GC1387@shiny> <50F43319.9040009@gmail.com> <20130114163433.GD1387@shiny>
In-Reply-To: <20130114163433.GD1387@shiny>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/01/13 16:34, Chris Mason wrote:
> On Mon, Jan 14, 2013 at 09:32:25AM -0700, Tomasz Kusmierz wrote:
>> On 14/01/13 15:57, Chris Mason wrote:
>>> On Mon, Jan 14, 2013 at 08:22:36AM -0700, Tomasz Kusmierz wrote:
>>>> On 14/01/13 14:59, Chris Mason wrote:
>>>>> On Mon, Jan 14, 2013 at 04:09:47AM -0700, Tomasz Kusmierz wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Since I had some free time over Christmas, I decided to conduct few
>>>>>> tests over btrFS to se how it will cope with "real life storage" for
>>>>>> normal "gray users" and I've found that filesystem will always mess up
>>>>>> your files that are larger than 10GB.
>>>>> Hi Tom,
>>>>>
>>>>> I'd like to nail down the test case a little better.
>>>>>
>>>>> 1) Create on one drive, fill with data
>>>>> 2) Add a second drive, convert to raid1
>>>>> 3) find corruptions?
>>>>>
>>>>> What happens if you start with two drives in raid1?  In other words, I'm
>>>>> trying to see if this is a problem with the conversion code.
>>>>>
>>>>> -chris
>>>> Ok, my description might be a bit enigmatic so to cut long story short
>>>> tests are:
>>>> 1) create a single drive default btrfs volume on single partition ->
>>>> fill with test data -> scrub -> admire errors.
>>>> 2) create a raid1 (-d raid1 -m raid1) volume with two partitions on
>>>> separate disk, each same size etc. -> fill with test data -> scrub ->
>>>> admire errors.
>>>> 3) create a raid10 (-d raid10 -m raid1) volume with four partitions on
>>>> separate disk, each same size etc. -> fill with test data -> scrub ->
>>>> admire errors.
>>>>
>>>> all disks are same age + size + model ... two different batches to avoid
>>>> same time failure.
>>> Ok, so we have two possible causes.  #1 btrfs is writing garbage to your
>>> disks.  #2 something in your kernel is corrupting your data.
>>>
>>> Since you're able to see this 100% of the time, lets assume that if #2
>>> were true, we'd be able to trigger it on other filesystems.
>>>
>>> So, I've attached an old friend, stress.sh.  Use it like this:
>>>
>>> stress.sh -n 5 -c <your source directory> -s <your btrfs mount point>
>>>
>>> It will run in a loop with 5 parallel processes and make 5 copies of
>>> your data set into the destination.  It will run forever until there are
>>> errors.  You can use a higher process count (-n) to force more
>>> concurrency and use more ram.  It may help to pin down all but 2 or 3 GB
>>> of your memory.
>>>
>>> What I'd like you to do is find a data set and command line that make
>>> the script find errors on btrfs.  Then, try the same thing on xfs or
>>> ext4 and let it run at least twice as long.  Then report back ;)
>>>
>>> -chris
>>>
>> Chris,
>>
>> Will do, just please be remember that 2TB of test data on "customer
>> grade" sata drives will take a while to test :)
> Many thanks.  You might want to start with a smaller data set, 20GB or
> so total.
>
> -chris
>
Chris & all,

Sorry for not replying for that long but Chris old friend "stress.sh" 
have proven that all my storage is affected with this bug and first 
thing was to bring everything down before corruptions will spread any 
further. Anyway for subject sake btrfs stress have failed after 2h, ext4 
stress have failed after 8h (according to "time ./stress.sh blablabla" ) 
- so it might be related to that ext4 always seamed slower on my machine 
than btrfs.


Anyway I wanted to use this opportunity to thank Chris and everybody 
related to btrfs development - your file system found a hidden bug in my 
set up that would be there until it would pretty much corrupt 
everything. I don't even want to think how much my main storage got 
corrupted over time (etx4 over lvm over md raid 5).

p.s. bizzare that when I "fill" ext4 partition with test data everything 
check's up OK (crc over all files), but with Chris tool it gets 
corrupted - for both Adaptec crappy pcie controller and for mother board 
built in one. Also since courses of history proven that my testing 
facilities are crap - any suggestion's on how can I test ram, cpu & 
controller would be appreciated.


