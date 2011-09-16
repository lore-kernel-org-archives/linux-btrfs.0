From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Fri, 16 Sep 2011 13:42:35 +0700
Message-ID: <CAG1y0sdvVP8swAULTxX9AvBghZRPYHjiWtL4kBNQGkfemmJ-HQ@mail.gmail.com>
References: <4E64D3D5.7020407@petaramesh.org>
	<15663472.1RTxtZJx8a@tethys>
	<CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
	<1411501.d4mgBNBG2i@tethys>
	<4E7253F4.9020005@gmail.com>
	<CAG1y0sdv=GwgRAd1suTGhzVB=A1dUsZ=fjiE67QsuGQCCQwSjw@mail.gmail.com>
	<1316154091.28427.3.camel@picard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316154091.28427.3.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2011 at 1:21 PM, Maciej Marcin Piechotka
<uzytkownik2@gmail.com> wrote:
> On Fri, 2011-09-16 at 05:16 +0700, Fajar A. Nugraha wrote:
>> On Fri, Sep 16, 2011 at 2:37 AM, Felix Blanke <felixblanke@gmail.com> wrote:
>> > I'm using btrfs since one year now and it's quite fast. I don't feel any
>> > differences to other filesystems. Never tried a benchmark but for my daily
>> > work it's nice.
>>
>> Your workload must be light :)
>>
>
> I recently repeatedly rsync whole partitions (>30GB) without ill
> effects. (ok - first sync took whole 1s).

Wait, you mean you sync 30GB data to another partition in one second?
It should not be possible for single HDD no matter what the filesystem
is. Unless you're using SSD or many HDD in raid.

That's how I'm using btrfs btw, on SSD, so I pretty much don't see the
"slowness" since the SSD is blazingly fast. Add to that the fact btrfs
has the features I need (compression, snapshot), and more
memory-efficient (compared to zfs), it's suitable for my needs.

>
>> >
>> > The advantage to ext4 for me is the build in raid1 and the snapshots. I'm
>> > using the snapshot feature for my local backups. I like it because it's
>> > really easy and uses very few storage. A simple "Snapshot -> Rsync to a
>> > different disk -> Snapshot" script is the perfect local backup method.
>> >
>>
>> you've never used zfs have you :)
>>
>> For that purpose, think "same feature as btrfs snapshot + rsync" but
>> without needing rsync. This can be very useful as the process of rsync
>> determining what data to transfer can be quite CPU/disk intensive.
>
> Now I'm curious - how do zsf get data off the partition without rsync?

First hit on Google: http://www.markround.com/archives/38-ZFS-Replication.html

As additinal info, zfs send/receive stream is at DMU layer, which (in
over-simplified term) is similar to raw disk blocks in normal
partition+ext4 setup. zfs keeps track of which blocks are used, so
when given two different snapshot, it can easily find out which blocks
are different. When using incremental send zfs only has to send those
blocks. It doesn't have to explicitly re-examine which parts of the
file is unmodified (thus not wasting disk, CPU, and network the way
rsync  does).

IIRC there was a proposal in this list sometime ago on implementing
similar functionality (send/receive) in btrfs. No actual working code
(yet) that I know of though.

-- 
Fajar
