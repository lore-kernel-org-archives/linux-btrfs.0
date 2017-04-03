Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34118 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdDCOJY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 10:09:24 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Robert Krig <robert.krig@render-wahnsinn.de>, linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <40314a4f-612b-ec45-36ba-75da52ddc9f9@render-wahnsinn.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1d84e84a-7fce-7d21-25c8-107453a75db6@mendix.com>
Date: Mon, 3 Apr 2017 16:09:22 +0200
MIME-Version: 1.0
In-Reply-To: <40314a4f-612b-ec45-36ba-75da52ddc9f9@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2017 03:50 PM, Robert Krig wrote:
> 
> 
> On 03.04.2017 12:11, Robert Krig wrote:
>> Hi guys, I seem to have run into a spot of trouble with my btrfs partition.
>>
>> I've got 4 x 8TB in a RAID1 BTRFS configuration.
>>
>> I'm running Debian Jessie 64 Bit, 4.9.0-0.bpo.2-amd64 kernel. Btrfs
>> progs version v4.7.3
>>
>> Server has 8GB of Ram.
>>
>>
>> I was running duperemove using a hashfile, which seemed to have run out
>> space and aborted. Then I tried a balance operation, with -dusage
>> progressively set to 0 1 5 15 30 50, which then aborted, I presume that
>> this caused the fs to mount readonly. I only noticed it somewhat later.
>>
>> I've since rebooted, and I can mount the filesystem OK, but after some
>> time (I presume caused by reads or writes) it once again switches to
>> readonly.
>>
>> I tried unmounting/remounting again and running a scrub, but the scrub
>> aborts after some time.
>>
>>
> 
> 
> I've compiled the newest btrfs-tools version 4.10.2
> 
> This is what I get when running a btrfsck -p /dev/sda
> 
> hecking filesystem on
> /dev/sda                                                                                                  
> 
> UUID:
> 8c4f8e26-3442-463f-ad8a-668dfef02593                                                                                       
> 
> incorrect offsets 8590
> 1258314415                                                                                                
> 
> bad block
> 38666170826752                                                                                                         
> 
>                                                                                                                                  
> 
> ERROR: errors found in extent allocation tree or chunk
> allocation                                                                
> Speicherzugriffsfehler
> 
> For the non-german speakers: Speicherzugriffsfehler = Memory Access Error
> 
> Dmesg shows this:
> 
> Apr 03 15:47:05 atlas kernel: btrfs[9140]: segfault at 9476b99e ip
> 000000000044c459 sp 00007fff556b4b10 error 4 in
> btrfs[400000+9d000]                    

That's probably because the tool does not verify if the numbers in the
fields make sense before using them.


-- 
Hans van Kranenburg
