From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 16:33:52 +0100
Message-ID: <ac3eb2510812170733r234ea389yac69fd4f5f1dc48b@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <ac3eb2510812170650j404edfb1h38aa86bbe3ffa2e@mail.gmail.com>
	 <20081217150813.GA2858@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Andreas Dilger" <adilger@sun.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Karel Zak" <kzak@redhat.com>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081217150813.GA2858@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2008 at 16:08, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Dec 17, 2008 at 03:50:45PM +0100, Kay Sievers wrote:
>> Sounds all sensible. Btrfs already stores the (possibly incomplete)
>> device tree state in the kernel, which should make things pretty easy
>> for userspace, compared to other already existing subsystems.
>>
>> We could have udev maintain a btrfs volume tree:
>>   /dev/btrfs/
>>   |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021
>>   |   |-- 897fac06-569c-4f45-a0b9-a1f91a9564d4 -> ../../sda10
>>   |   `-- aac20975-b642-4650-b65b-b92ce22616f2 -> ../../sda9
>>   `-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2
>>       |-- 4d1f1fff-4c6b-4b87-8486-36f58abc0610 -> ../../sdb2
>>       `-- e7fe3065-c39f-4295-a099-a89e839ae350 -> ../../sdb1
>>
>> At the same time, by-uuid/ is created:
>>   /dev/disk/by-uuid/
>>   |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021 -> ../../sda10
>>   |-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2 -> ../../sdb2
>>   ...
>
> Well, it's not just btrfs, it's also md, lvm and xfs.  I think the right
> way is to make the single node for the /dev/disk/by-uuid/ just a legacy
> case for potential multiple devices.  E.g. by having
>
> /dev/disk/by-uuid/
>        0cdedd75-2d03-41e6-a1eb-156c0920a021    -> ../../sda10
>        0cdedd75-2d03-41e6-a1eb-156c0920a021.d
>                foo                             -> ../../sda10
>                bar                             -> ../../sda9
>
> where foo nad bar could be uuids if the filesystem / volume manager
> supports it, otherwise just the short name for it.

Sure, we can do something like that. /dev/btrfs/ was just something
for me to start with, and see how the stuff works.

>> For recue and recovery cases, it will still be nice to be able to
>> trigger "scan all devices" code in btrfsctrl (own code or libbklid),
>> but it should be avoided in any normal operation mode.
>
> Again, that's something we should do generically for the whole
> /dev/disk/ tree.   For that we need to merge libvolume_id and libblkid
> so that it has a few related but separate use cases:
>
>  - a lowlevel probe what fs / volume manager / etc is this for
>   the udev callout, mkfs, strip size detection etc

A low-level api will be offered by a future libblkid version in util-linux-ng.

>  - a way to rescan everything, either for non-udev static /dev case
>   or your above recovery scenario

The scan code is part of libblkid, we just need some explicit controls
to enable disable the scanning. It should never be the default, like
it is today.

>  - plus potentially some sort of caching for the non-recovery static
>   /dev case

It's also in libblkid. Today it's pretty useless to cache stuff
indexed by major/minor, but it's there.

> I've long planned to put you and Ted into a room and not let you out
> until we see white smoke :)

A new libblkid already happened at:
  http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=shortlog;h=topic/blkid

Almost all of libvolume_id is already merged into this new version
(only btrfs is missing :)). Udev will switch over to calling blkid
when it's available in a released version of util-linux-ng. I will
just delete the current libvolume_id library after that.

No white smoke, if all works out as planned. :)

Thanks,
Kay
