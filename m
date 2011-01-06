From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 14:49:39 +0000
Message-ID: <4D25D683.3050609@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>	<4D24D8BC.90808@bobich.net> <4D251888.7060508@shiftmail.org> <20110106143019.GB14674@mother>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110106143019.GB14674@mother>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Torcz wrote:
> On Thu, Jan 06, 2011 at 02:19:04AM +0100, Spelic wrote:
>>> CPU can handle considerably more than 250 block hashings per
>>> second. You could argue that this changes in cases of sequential
>>> I/O on big files, but a 1.86GHz GHz Core2 can churn through
>>> 111MB/s of SHA256, which even SSDs will struggle to keep up with.
>> A normal 1TB disk with platters can do 130MB/sec sequential, no prob=
lems.
>> A SSD can do more like 200MB/sec write 280MB/sec read sequential or
>> random and is actually limited only by the SATA 3.0gbit/sec but soon
>> enough they will have SATA/SAS 6.0gbit/sec.
>=20
>   By =E2=80=9Csoon enough=E2=80=9D you really meant =E2=80=9Ca year a=
go=E2=80=9D, I think:
> http://www.anandtech.com/show/3812/the-ssd-diaries-crucials-realssd-c=
300
> Current 6Gbps SSD are doing 415 MB/s sequential:
> http://www.anandtech.com/show/4086/microns-realssd-c400-uses-25nm-nan=
d-at-161gb-offers-415mbs-reads
> or even claim 550MB/s:
> http://www.anandtech.com/show/4100/ocz-vertex-pro-3-demo-worlds-first=
-sandforce-sf2000
> (funny bit: Sandforce SSD controllers dedup internally).=20
>=20
>   Anyway, 6Gbps is not a future tale, but something long available.
> And not the fastest kids on the block:  currently build filesystems
> must deal storage providing many gigabytes per second.  Think
> of massive disk arrays or stuff like Oracle F5100, claiming
> 12.8GB/sec read and ~10GB/s write (in one rack unit).

Sequential figures look nice and impressive but we all know they are=20
meaningless for most real world workloads. IOPS are where it's at. And=20
maybe you can get 100,000 IOPS out of an SSD. But that still means=20
100,000 SHA256 hashes/second. That's 3.2MB/s of SHA256 hashes, or about=
=20
2% of what a modern x64 CPU will do, assuming it doesn't have a suitabl=
e=20
hardware crypto accelerator for that algorithm. So on a reasonably=20
recent quad core CPU you would probably be able to comfortably handle=20
about 200x that before it starts becoming an issue. If you're that=20
concerned about space requirements, doing LZO compression will still be=
=20
much more expensive.

And that's only for writes - on reads we don't need to do any hashing=20
(although it's useful to do for the disk error checking reasons=20
explained earlier).

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
