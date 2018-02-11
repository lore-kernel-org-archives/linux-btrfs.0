Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:37748 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbeBKSYO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 13:24:14 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>, Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <20180210220549.GA30438@polanet.pl>
 <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com>
Date: Sun, 11 Feb 2018 19:24:12 +0100
MIME-Version: 1.0
In-Reply-To: <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2018 04:59 PM, Ellis H. Wilson III wrote:
> Thanks Tomasz,
> 
> Comments in-line:
> 
> On 02/10/2018 05:05 PM, Tomasz Pala wrote:
>> You won't have anything close to "accurate" in btrfs - quotas don't
>> include space wasted by fragmentation, which happens to allocate from
>> tens
>> to thousands times (sic!) more space than the files itself.
>> Not in some worst-case scenarios, but in real life situations...
>> I got 10 MB db-file which was eating 10 GB of space after a week of
>> regular updates - withOUT snapshotting it. All described here.
> 
> The underlying filesystem this is replacing was an in-house developed
> COW filesystem, so we're aware of the difficulties of fragmentation. I'm
> more interested in an approximate space consumed across snapshots when
> considering CoW.  I realize it will be approximate.  Approximate is ok
> for us -- no accounting for snapshot space consumed is not.

If your goal is to have an approximate idea for accounting, and you
don't need to be able to actually enforce limits, and if the filesystems
that you are using are as small as the 40GiB example you gave...

Why not just use `btrfs fi du <subvol> <snap1> <snap2>` now and then and
update your administration with the results? .. Instead of putting the
burden of keeping track of all administration during every tiny change
all day long?

> Also, I don't see the thread you mentioned.  Perhaps you forgot to
> mention it, or an html link didn't come through properly?
> 
>>> course) or how many subvolumes/snapshots there are.  If I know that
>>> above N snapshots per subvolume performance tanks by M%, I can apply
>>> limits on the use-case in the field, but I am not aware of those kinds
>>> of performance implications yet.
>>
>> This doesn't work like this. It all depends on data that are subject of
>> snapshots, especially how they are updated. How exactly, including write
>> patterns.
>>
>> I think you expect answers that can't be formulated - with fs
>> architecture so
>> advanced as ZFS or btrfs it's behavior can't be analyzed for simple
>> answers like 'keep less than N snapshots'.
> 
> I was using an extremely simple heuristic to drive at what I was looking
> to get out of this.  I should have been more explicit that the example
> was not to be taken literally.
> 
>> This is an exception of easy-answer: btrfs doesn't handle databases with
>> CoW. Period. Doesn't matter if snapshotted or not, ANY database files
>> (systemd-journal, PostgreSQL, sqlite, db) are not handled at all. They
>> slow down entire system to the speed of cheap SD card.
> 
> I will keep this in mind, thank you.  We do have a higher level above
> BTRFS that stages data.  I will consider implementing an algorithm to
> add the nocow flag to the file if it has been written to sufficiently to
> indicate it will be a bad fit for the BTRFS COW algorithm.

Adding nocow attribute to a file only works when it's just created and
not written to yet or when setting it on the containing directory and
letting it inherit for new files. You can't just turn it on for existing
files with content.

https://btrfs.wiki.kernel.org/index.php/FAQ#Can_copy-on-write_be_turned_off_for_data_blocks.3F

>> Actually, if you do not use compression and don't need checksums of data
>> blocks, you may want to mount all the btrfs with nocow by default.
>> This way the quotas would be more accurate (no fragmentation _between_
>> snapshots) and you'll have some decent performance with snapshots.
>> If that is all you care.
> 
> CoW is still valuable for us as we're shooting to support on the order
> of hundreds of snapshots per subvolume,

Hundreds will get you into trouble even without qgroups.

> and without it (if BTRFS COW
> works the same as our old COW FS) that's going to be quite expensive to
> keep snapshots around.  So some hybrid solution is required here.

-- 
Hans van Kranenburg
