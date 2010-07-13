From: jck <jck@archlinux.us>
Subject: Re: Disk space usage displayed incorrectly?
Date: Tue, 13 Jul 2010 07:23:25 +0530
Message-ID: <AANLkTilNCSreFX_F4Ik-tiYwGg9ARG3XvA_sWwyQEavp@mail.gmail.com>
References: <AANLkTil1adG5cmYxbjvzv7OygH9q12SyA2HL8bOWtuxp@mail.gmail.com>
	<20100713011650.GN563@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, jck <jck@archlinux.us>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100713011650.GN563@think>
List-ID: <linux-btrfs.vger.kernel.org>

I tested it and the partition gets filled at 123.58 GB, the 60GB is
getting wasted. is there anything i can do about this?

On Tue, Jul 13, 2010 at 6:46 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Sat, Jul 10, 2010 at 07:22:26AM +0530, jck wrote:
>> Hello,
>> when i check diskspace usage of a btrfs partition using df i get the
>> wrong free space, this is expected i think.
>
> We do try to take the raid levels into account during df, but only fo=
r
> the space that is already allocated.
>
>> However even when i use 'btrfs filesystem df' I get wrong freespace:
>> Data: total=3D123.58GB, used=3D87.31GB
>> Metadata: total=3D61.00GB, used=3D396.29MB
>> System: total=3D32.00MB, used=3D16.00KB
>>
>> Does this mean that after the 123 GB of 'Data' fills up I wont be ab=
le
>> to add more stuff to the partition?
>> I'm using btrfs-progs-git (jul 10)
>
> This does reflect the space that is allocated, but the drive itself m=
ay
> have more free space. =A0btrfs filesystem show will give you a few mo=
re
> details.
>
> Basically btrfs allocates from the drive in chunks of about 1GB and t=
hen
> puts the file data or metadata into those chunks. =A0So if you do a m=
kfs
> and then create one file, you might have 1TB of space on the drive th=
at
> hasn't been allocated yet.
>
> -chris
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
