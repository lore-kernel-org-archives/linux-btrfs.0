From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 16:33:41 +0100
Message-ID: <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>
References: <hnnijd$jol$1@dough.gmane.org> <hnq3pd$801$1@dough.gmane.org>
	 <201003170948.18819.hjclaes@web.de>
	 <201003171625.50257.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
To: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003171625.50257.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 17, 2010 at 4:25 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Wednesday 17 March 2010 09:48:18 Heinz-Josef Claes wrote:
>> Hi,
>>
>> just want to add one correction to your thoughts:
>>
>> Storage is not cheap if you think about enterprise storage on a SAN,
>> replicated to another data centre. Using dedup on the storage boxes =
leads
>> =A0to performance issues and other problems - only NetApp is offerin=
g this at
>> =A0the moment and it's not heavily used (because of the issues).
>
> there are at least two other suppliers with inline dedup products and=
 there is
> OSS solution: lessfs
>
>> So I think it would be a big advantage for professional use to have =
dedup
>> build into the filesystem - processors are faster and faster today a=
nd not
>> =A0the cost drivers any more. I do not think it's a problem to "spen=
d" on
>> =A0core of a 2 socket box with 12 cores for this purpose.
>> Storage is cost intensive:
>> - SAN boxes are expensive
>> - RAID5 in two locations is expensive
>> - FC lines between locations is expensive (depeding very much on whe=
re you
>> are).
>
> In-line dedup is expensive in two ways: first you have to cache the d=
ata going
> to disk and generate checksum for it, then you have to look if such b=
lock is
> already stored -- if the database doesn't fit into RAM (for a VM host=
 it's more
> than likely) it requires at least few disk seeks, if not a few dozen =
for
> really big databases. Then you should read the block/extent back and =
compare
> them bit for bit. And only then write the data to the disk. That redu=
ces your
> IOPS by at least an order of maginitude, if not more.

Sun decided that with SHA256 (which ZFS uses for normal checksumming)
collisions are unlikely enough to skip the read/compare step:
http://blogs.sun.com/bonwick/entry/zfs_dedup . That's not the case, of
course, with btrfs-used CRC32, but a switch to a stronger hash would
be recommended to reduce collisions anyway. And yes, for the truly
paranoid, a forced verification (after the hashes match) is always an
option.

>
> For post-process dedup you can go as fast as your HDDs will allow you=
=2E And
> then, when your machine is mostly idle you can go and churn through t=
he data.
>
> IMHO in-line dedup is a good thing only as storage for backups -- whe=
n you
> have high probability that the stored data is duplicated (and with a =
1:10
> dedup ratio you have 90% probability, it is).
>
> So the CPU cost is only one factor. HDDs are a major bottleneck too.
>
> All things considered, it would be best to have both post-process and=
 in-line
> data deduplication, but I think, that in-line dedup will see much les=
s use.
>
>>
>> Naturally, you would not use this feature for all kind of use cases =
(eg.
>> heavily used database), but I think there is enough need.
>>
>> my 2 cents,
>> Heinz-Josef Claes
> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>
> System Zarz=B1dzania Jako=B6ci=B1
> zgodny z norm=B1 ISO 9001:2000
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
