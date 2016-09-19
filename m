Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37046 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbcISRSw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:18:52 -0400
Received: by mail-it0-f46.google.com with SMTP id 186so77659232itf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 10:18:51 -0700 (PDT)
Subject: Re: stability matrix
To: linux-btrfs@vger.kernel.org, dave@jikos.cz,
        Christoph Anton Mitterer <calestyo@scientia.net>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net> <20160919152753.GG933@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bc71caf0-4656-382b-479d-e135ee7f4bc7@gmail.com>
Date: Mon, 19 Sep 2016 13:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <20160919152753.GG933@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 11:27, David Sterba wrote:
> Hi,
>
> On Thu, Sep 15, 2016 at 04:14:04AM +0200, Christoph Anton Mitterer wrote:
>> In general:
>> - I think another column should be added, which tells when and for
>>   which kernel version the feature-status of each row was
>>   revised/updated the last time and especially by whom.
>>   If a core dev makes a statement on a particular feature, this
>>   probably means much more, than if it was made by "just" a list
>>   regular.
>
> It's going to be revised per release. If there's a bug that affect the
> status, the page will be updated. I'm going to do that among other
> per-release regular boring tasks.
>
> I'm still not decided if the kernel version will be useful enough, but
> if anybody is willing to do the research and fill the table I don't
> object.
Moving forwards, I think it's worth it, but I don't feel that it's worth 
looking back at anything before 4.4 to list versions.
>
>>   And yes I know, in the beginning it already says "this is for 4.7"...
>>   but let's be honest, it's pretty likely when this is bumped to 4.8
>>   that not each and every point will be thoroughly checked again.
>> - Optionally even one further column could be added, that lists bugs
>>   where the specific cases are kept record of (if any).
>
> There's a new section under the table to write anything that would not
> fit. Mostly pointers to other documentation (manual pages) or bugzilla.
>
>> - Perhaps a 3rd Status like "eats-your-data" which is worse than
>>   critical, e.g. for things were it's known that there is a high
>>   chance for still getting data corruption (RAID56?)
>>
>>
>> Perhaps there should be another section that lists general caveats
>> and pitfalls including:
>> - defrag/auto-defrag causes ref-link break up (which in turn causes
>>   possible extensive space being eaten up)
>
> Updated accordingly.
>
>> - nodatacow files are not yet[0] checksummed, which in turn means
>>   that any errors (especially silent data corruption) will not be
>>   noticed AND which in turn also means the data itself cannot be
>>   repaired even in case of RAIDs (only the RAIDs are made consistent
>>   again)
>
> Added to the table.
>
>> - subvolume UUID attacks discussed in the recent thread
>> - fs/device UUID collisions
>>   - the accidental corruption that can happen in case colliding
>>     fs/device UUIDs appear in a system (and telling the user that
>>     this is e.g. the case when dd'ing and image or using lvm
>>     snapshots, probably also when having btrfs on MD RAID1 or RAID10)
>>   - the attacks that are possible when UUIDs are known to an attacker
>
> That's more like a usecase, thats out of the scope of the tabular
> overview. But we have an existing page UseCases that I'd like to
> transform to a more structured and complete overview of usceases of
> various features, so the UUID collisions would build on top of that with
> "and this could hapen if ...".
I don't agree with this being use case specific.  Whether or not someone 
cares could technically be use case specific, but the use cases where 
this actually doesn't matter is pretty much limited to tight embedded 
systems with no way to attach external storage.  This behavior results 
in both a number of severe security holes for anyone without proper 
physical security (read as 'almost all desktop and laptop users, as well 
as many server admins'), and severe potential for data loss when 
performing normal recovery activities that work on every other filesystem.
>
>> - in-band dedupe
>>   deduped are IIRC not bitwise compared by the kernel before de-duping,
>>   as it's the case with offline dedupe.
>>   Even if this is considered safe by the community... I think users
>>   should be told.
>
> Only features merged are reflected. And the out-of-band dedupe does full
> memcpy. See btrfs_cmp_data() called from btrfs_extent_same().
>
>> - btrfs check --repair (and others?)
>>   Telling people that this may often cause more harm than good.
>
> I think userspace tools do not belong to the overview.
>
>> - even mounting a fs ro, may cause it to be changed
>
> This would go to the UseCases
My same argument about the UUID issues applies here, just without the 
security aspect.  The only difference here is that it's common behavior 
across most filesystems (but not widely known to most people who aren't 
FS develo9pers or sysops experts).
>
>> - DB/VM-image like IO patterns + nodatacow + (!)checksumming
>>   + (auto)defrag + snapshots
>>   a)
>>   People typically may have the impression:
>>   btrfs = checksummed => als is guaranteed to be "valid" (or at least
>>   noticed)
>>   However this isn't the case for nodatacow'ed files, which in turn is
>>   kinda "mandatory" for DB/VM-image like IO patterns, cause otherwise
>>   these would fragment to heavily (see (b).
>>   Unless claimed by some people, none of the major DBs or VM-image
>>   formats do general checksumming on their own, most even don't support
>>   it, some that do wouldn't do it without app-support and few "just"
>>   don't do it per default.
>>   Thus one should bump people to this situation and that they may not
>>   get this "correctness" guarantee here.
>>   b)
>>   IIRC, it doesn't even help to simply not use nodatacow on such files
>>   and using auto-defrag instead to countermeasure the fragmenting, as
>>   that one doesn't perform too well on large files.
>
> Same.
>
>> For specific features:
>> - Autodefrag
>>   - didn't that also cause reflinks to be broken up?
>
> No and never had.
>
>> that should be
>>     mentioned than as well, as it is (more or less) for defrag and
>>     people could then assume it's not the case for autodefrag (which I
>>     did initially)
>>   - wasn't it said that autodefrag performs bad with files > ~1GB?
>>     Perhaps that should be mentioned too
>> - defrag
>>   "extents get unshared" is IMO not an adequate description for the end
>>   user,... it should perhaps link to the defrag article and there
>>   explain in detail that any ref-linked files will be broken up, which
>>   means space usage will increase, and may especially explode in case
>>   of snapshots
>
> Added more verbose description.
>
>> - all the RAID56 related points
>>   wasn't there recently a thread that discussed a more serious bug,
>>   where parity was wrongly re-calculated which in turn caused actual
>>   data corruption?
>>   I think if that's still an issue "write hole still exists, parity
>>   not checksummed" is not enough but one should emphasize that data may
>>   easily be corrupted.
>
> There's a separate page for raid56 listing all known problems but I
> don't see this one there.
>
>> - RAID*
>>   No userland tools for monitoring/etc.
>
> That's a usability bug.
While it's a usability bug, it's still an important piece of information 
for people who are looking at this for production usage, and due to the 
generally shoddy documentation, is something that's not hard to overlook.
>
>> - Device replace
>>   IIRC, CM told me that this may cause severe troubles on RAID56
>>
>> Also, the current matrix talks about "auto-repair"... what's that? (=>
>> should be IMO explained).
>
> Added.
>
>> Last but not least, perhaps this article may also be the place to
>> document 3rd party things and how far they work stable with btrfs.
>> For example:
>> - Which grub version supports booting from it? Which features does it
>>   [not] support (e.g. which RAIDs, skinny-extents, etc.)?
>> - Which forensic tools (e.g. things like testdisk) do work with btrfs?
>> - Which are still maintained/working dedupe userland tools (and are
>>   they stable?)
>
> This is getting a bit out of the scope. If the information on our wiki
> is static, ie 'grub2 since 2.02~beta18 supports something', then ok, but
> we still should point readers to the official wikis or documentation.
>
> Auditing the bootloaders for btrfs support is one of the unclaimed
> project ideas.
>
>> [0] Yeah I know, a number of list regulars constantly tried to convince
>>     me that this wasn't possible per se, but a recent discussion I had
>>     with CM seemed to have revealed (unless I understood it wrong) that
>>     it wouldn't be generally impossible at all.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

