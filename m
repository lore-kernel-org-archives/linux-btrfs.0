Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C6CC10F06
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F37F21773
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfCaOhg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:37:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:42030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731200AbfCaOhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:37:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0F11AD2C;
        Sun, 31 Mar 2019 14:37:33 +0000 (UTC)
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Alberto Bursi <alberto.bursi@outlook.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
 <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
 <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
 <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e67b8b50-dd2a-2106-5362-913167ea48a8@suse.de>
Date:   Sun, 31 Mar 2019 16:37:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/31/19 4:17 PM, Qu Wenruo wrote:
> 
> 
> On 2019/3/31 下午9:36, Hannes Reinecke wrote:
>> On 3/31/19 2:00 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2019/3/31 下午7:27, Alberto Bursi wrote:
>>>>
>>>> On 30/03/19 13:31, Qu Wenruo wrote:
>>>>> Hi,
>>>>>
>>>>> I'm wondering if it's possible that certain physical device doesn't
>>>>> handle flush correctly.
>>>>>
>>>>> E.g. some vendor does some complex logical in their hdd controller to
>>>>> skip certain flush request (but not all, obviously) to improve
>>>>> performance?
>>>>>
>>>>> Do anyone see such reports?
>>>>>
>>>>> And if proves to happened before, how do we users detect such problem?
>>>>>
>>>>> Can we just check the flush time against the write before flush call?
>>>>> E.g. write X random blocks into that device, call fsync() on it, check
>>>>> the execution time. Repeat Y times, and compare the avg/std.
>>>>> And change X to 2X/4X/..., repeat above check.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>
>>>> Afaik HDDs and SSDs do lie to fsync()
>>>
>>> fsync() on block device is interpreted into FLUSH bio.
>>>
>>> If all/most consumer level SATA HDD/SSD devices are lying, then there is
>>> no power loss safety at all for any fs. As most fs relies on FLUSH bio
>>> to implement barrier.
>>>
>>> And for fs with generation check, they all should report metadata from
>>> the future every time a crash happens, or even worse gracefully
>>> umounting fs would cause corruption.
>>>
>> Please, stop making assumptions.
> 
> I'm not.
> 
>>
>> Disks don't 'lie' about anything, they report things according to the
>> (SCSI) standard.
>> And the SCSI standard has two ways of ensuring that things are written
>> to disk: the SYNCHRONIZE_CACHE command and the FUA (force unit access)
>> bit in the command.
> 
> I understand FLUSH and FUA.
> 
>> The latter provides a way of ensuring that a single command made it to
>> disk, and the former instructs the driver to:
>>
>> "a) perform a write medium operation to the LBA using the logical block
>> data in volatile cache; or
>> b) write the logical block to the non-volatile cache, if any."
>>
>> which means it's perfectly fine to treat the write-cache as a
>> _non-volative_ cache if the RAID HBA is battery backed, and thus can
>> make sure that outstanding I/O can be written back even in the case of a
>> power failure.
>>
>> The FUA handling, OTOH, is another matter, and indeed is causing some
>> raised eyebrows when comparing it to the spec. But that's another story.
> 
> I don't care FUA as much, since libata still doesn't support FUA by
> default and interpret it as FLUSH/WRITE/FLUSH, so it doesn't make things
> worse.
> 
> I'm more interesting in, are all SATA/NVMe disks follows this FLUSH
> behavior?
> 
They have to to be spec compliant.

> For most case, I believe it is, or whatever the fs is, either CoW based
> or journal based, we're going to see tons of problems, even gracefully
> unmounted fs can have corruption if FLUSH is not implemented well.
> 
> I'm interested in, is there some device doesn't completely follow
> regular FLUSH requirement, but do some tricks, for certain tested fs.
> 
Not that I'm aware of.

> E.g. the disk is only tested for certain fs, and that fs always does
> something like flush, write flush, fua.
> In that case, if the controller decides to skip the 2nd flush, but only
> do the first flush and fua, if the 2nd write is very small (e.g.
> journal), the chance of corruption is pretty low due to the small window.
> 
Highly unlikely.
Tweaking flush handling in this way is IMO far too complicated, and 
would only add to the complexity of adding flush handling in firmware in 
the first place.
Whereas the whole point of this exercise would be to _reduce_ complexity 
in firmware (no-one really cares about the hardware here; that's already 
factored in during manufacturing, and reliability is measured in such a 
broad way that it doesn't make sense for the manufacture to try to 
'improve' reliability by tweaking the flush algorithm).
So if someone would be wanting to save money they'd do away with the 
entire flush handling and do not implement a write cache at all.
That even saves them money on the hardware, too.

Cheers,

Hannes
-- 
r. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
