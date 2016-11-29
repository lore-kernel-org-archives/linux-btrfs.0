Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35051 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750754AbcK2Xtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 18:49:35 -0500
Received: by mail-yw0-f182.google.com with SMTP id i145so148219424ywg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 15:49:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com> <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 29 Nov 2016 16:49:33 -0700
Message-ID: <CAJCQCtRJRF5j+Dvx+K2DiRyq84xdWxPPzndc-rnor30tWyOFTg@mail.gmail.com>
Subject: Re: Convert from RAID 5 to 10
To: Wilson Meier <wilson.meier@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2016 at 4:16 PM, Wilson Meier <wilson.meier@gmail.com> wrote:
>
>
> On 29.11.2016 23:52, Chris Murphy wrote:
>> On Tue, Nov 29, 2016 at 3:34 PM, Wilson Meier <wilson.meier@gmail.com> wrote:
>>> On 29.11.2016 18:54, Austin S. Hemmelgarn wrote:
>>>> On 2016-11-29 12:20, Florian Lindner wrote:
>>>>> Hello,
>>>>>
>>>>> I have 4 harddisks with 3TB capacity each. They are all used in a
>>>>> btrfs RAID 5. It has come to my attention, that there
>>>>> seem to be major flaws in btrfs' raid 5 implementation. Because of
>>>>> that, I want to convert the the raid 5 to a raid 10
>>>>> and I have several questions.
>>>>>
>>>>> * Is that possible as an online conversion?
>>>> Yes, as long as you have a complete array to begin with (converting from
>>>> a degraded raid5/6 array has the same issues as rebuilding a degraded
>>>> raid5/6 array).
>>>>>
>>>>> * Since my effective capacity will shrink during conversions, does
>>>>> btrfs check if there is enough free capacity to
>>>>> convert? As you see below, right now it's probably too full, but I'm
>>>>> going to delete some stuff.
>>>> No, you'll have to do the math yourself.  This would be a great project
>>>> idea to place on the wiki though.
>>>>>
>>>>> * I understand the command to convert is
>>>>>
>>>>> btrfs balance start -dconvert=raid10 -mconvert=raid10 /mnt
>>>>>
>>>>> Correct?
>>>> Yes, but I would personally convert first metadata then data.  The
>>>> raid10 profile gets better performance than raid5, so converting the
>>>> metadata first (by issuing a balance just covering the metadata) should
>>>> speed up the data conversion a bit).
>>>>>
>>>>> * What disks are allowed to fail? My understanding of a raid 10 is
>>>>> like that
>>>>>
>>>>> disks = {a, b, c, d}
>>>>>
>>>>> raid0( raid1(a, b), raid1(c, d) )
>>>>>
>>>>> This way (a XOR b) AND (c XOR d) are allowed to fail without the raid
>>>>> to fail (either a or b and c or d are allowed to fail)
>>>>>
>>>>> How is that with a btrfs raid 10?
>>>> A BTRFS raid10 can only sustain one disk failure.  Ideally, it would
>>>> work like you show, but in practice it doesn't.
>>> I'm a little bit concerned right now. I migrated my 4 disk raid6 to
>>> raid10 because of the known raid5/6 problems. I assumed that btrfs
>>> raid10 can handle 2 disk failures as longs as they occur in different
>>> stripes.
>>> Could you please point out why it cannot sustain 2 disk failures?
>>
>> Conventional raid10 has a fixed assignment of which drives are
>> mirrored pairs, and this doesn't happen with Btrfs at the device level
>> but rather the chunk level. And a chunk stripe number is not fixed to
>> a particular device, therefore it's possible a device will have more
>> than one chunk stripe number. So what that means is the loss of two
>> devices has a pretty decent chance of resulting in the loss of both
>> copies of a chunk, whereas conventional RAID 10 must lose both
>> mirrored pairs for data loss to happen.
>>
>> With very cursory testing what I've found is btrfs-progs establishes
>> an initial stripe number to device mapping that's different than the
>> kernel code. The kernel code appears to be pretty consistent so long
>> as the member devices are identically sized. So it's probably not an
>> unfixable problem, but the effect is that right now Btrfs raid10
>> profile is more like raid0+1.
>>
>> You can use
>> $ sudo btrfs insp dump-tr -t 3 /dev/
>>
>> That will dump the chunk tree, and you can see if any device has more
>> than one chunk stripe number associated with it.
>>
>>
> Huh, that makes sense. That probably should be fixed :)
>
> Given your advised command (extended it a bit for readability):
> # btrfs insp dump-tr -t 3 /dev/mapper/luks-2.1 | grep "stripe " | awk '{
> print $1" "$2" "$3" "$4 }' | sort -u
>
> I get:
> stripe 0 devid 1
> stripe 0 devid 4
> stripe 1 devid 2
> stripe 1 devid 3
> stripe 1 devid 4
> stripe 2 devid 1
> stripe 2 devid 2
> stripe 2 devid 3
> stripe 3 devid 1
> stripe 3 devid 2
> stripe 3 devid 3
> stripe 3 devid 4
>
> Now i'm even more concerned!

Uhh yeah, this is a four device raid10? I'm a little confused why it's
not consistently showing four stripes per chunk, which would mean the
same number of strip 0's as stripe 3's. I don't know what that's
about.

A full balance might make the mapping consistent.

> That said, btrfs shouldn't be used for other then raid1 as every other
> raid level has serious problems or at least doesn't work as the expected
> raid level (in terms of failure recovery).

Well, raid1 is also single device failure tolerance only as well.
There is no device n raid1.


-- 
Chris Murphy
