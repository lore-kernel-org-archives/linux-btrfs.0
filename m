From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 09:16:40 +0800
Message-ID: <4F42F078.2030408@cn.fujitsu.com>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com> <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tom@drdabbles.us, linux-btrfs@vger.kernel.org
To: Wes <anomaly256@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/21/2012 08:45 AM, Wes wrote:
> I've noticed similar behavior when even RAID0'ing an odd number of
> devices which should be even more trivial in practice.
> You would expect something like:
> sda A1 B1
> sdb A2 B2
> sdc A3 B3
> 
> or at least, if BTRFS can only handle block pairs,
> 
> sda  A1 B2
> sdb  A2 C1
> sdc  B1 C2
> 
> But the end result was that disk usage and reporting went all out of
> whack, allocation reporting got confused and started returning
> impossible values, and very shortly after the entire FS was corrupted.
>  Rebalancing messed everything up royally and in the end I concluded
> to simply not use an odd number of drives with BTRFS.
> 
> I also tried RAID1 with an odd number of drives, expecting to have 2
> redundant mirrors.  Instead the end result was that the blocks were
> still only allocated in pairs, and since they were allocated
> round-robbin on the drives I completely lost the ability to remove any
> single drive from the array without data loss.
> 
> ie:
> Instead of:
> sda A1 B1
> sdb A1 B1
> sdc A1 B1
> 
> it ended up doing:
> 
> sda A1 B1
> sdb A1 C1
> sdc B1 C1
> 
> meaning removing any 1 drive would result in lost data.
> 

Removing any disk will not lose data cause btrfs ensure all the data in the removed disk is
safely placed on right places.  And if there is not enough rest space for the data,
the remove operations will fail.  Or what am I missing?

thanks,
liubo

> I was told that this issue should have been resolved a while ago by a
> dev at Linuxconf, however this test of mine was only about 2 months
> ago.
> 
> 
> 
> 
> On Tue, Feb 21, 2012 at 11:35 AM, Tom Cameron <tomc603@gmail.com> wrote:
>> I had a 4 drive RAID10 btrfs setup that I added a fifth drive to with
>> the "btrfs device add" command. Once the device was added, I used the
>> balance command to distribute the data through the drives. This
>> resulted in an infinite run of the btrfs tool with data moving back
>> and forth across the drives over and over again. When using the "btrfs
>> filesystem show" command, I could see the same pattern repeated in the
>> byte counts on each of the drives.
>>
>> It would probably add more complexity to the code, but adding a check
>> for loops like this may be handy. While a 5-drive RAID10 array is a
>> weird configuration (I'm waiting for a case with 6 bays), it _should_
>> be possible with filesystems like BTRFS. In my head, the distribution
>> of data would be uneven across drives, but the duplicate and stripe
>> count should be even at the end. I'd imagine it to look something like
>> this:
>>
>> D1: A1 B1 C1 D1
>> D2: A1 B1 C1    E1
>> D3: A2 B2    D1 E1
>> D4: A2    C2 D2 E2
>> D5:    B2 C2 D2 E2
>>
>> This is obviously over simplified, but the general idea is the same. I
>> haven't looked into the way the "RAID"ing of objects works in BTRFS
>> yet, but because it's a filesystem and not a block-based system it
>> should be smart enough to care only about the duplication and striping
>> of data, and not the actual block-level or extent-level balancing.
>> Thoughts?
>>
>> Thanks in advance!
>> Tom
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

