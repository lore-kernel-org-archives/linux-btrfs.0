From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: How to expand a BTRFS partition... backwards
Date: Sun, 2 May 2010 08:23:04 +0200
Message-ID: <v2x8a48dc7a1005012323je884dfc4qc7a7f7bd67f786aa@mail.gmail.com>
References: <j2v8a48dc7a1005012232pa765876fscc41e97b940333de@mail.gmail.com>
	 <4BDD128C.7020606@a-city.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: TAXI <taxi@a-city.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BDD128C.7020606@a-city.de>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, I figured that the new btrfs tool would have something easier.
Now I only need to know whether expanding btrfs is also possible
backwards on the harddrive.

Regards,
Sebastian J.

On 2 May 2010 07:50, TAXI <taxi@a-city.de> wrote:
> The manpage says:
> =C2=A0 =C2=A0 =C2=A0 filesystem resize [+/-]<size>[gkm]|max <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize =C2=A0a filesy=
stem identified by <path>. =C2=A0The <size>
> parameter
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specifies the new siz=
e of the filesystem. =C2=A0If the prefix +
> or =C2=A0-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is =C2=A0present =C2=A0=
the =C2=A0size is increased or decreased by the
> quantity
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size>. =C2=A0If no u=
nits are =C2=A0specified, =C2=A0the =C2=A0unit =C2=A0of =C2=A0the
> <size>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parameter =C2=A0defau=
lts to bytes. Optionally, the size
> parameter may
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0be suffixed by one of=
 the following the units designators:
> =C2=A0'K',
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0'M', or 'G', kilobyte=
s, megabytes, or gigabytes, respectively.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If =C2=A0'max' =C2=A0=
is =C2=A0passed, =C2=A0the filesystem will occupy all
> available
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volume(s=
).
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command do=
es not manipulate the =C2=A0size =C2=A0of
> underlying
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partition. =C2=A0If y=
ou wish to enlarge/reduce a filesystem,
> you must
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0make sure you can exp=
and =C2=A0the =C2=A0partition =C2=A0before
> enlarging =C2=A0the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filesystem =C2=A0and =
=C2=A0shrink the partition after reducing the
> size of
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the filesystem.
>
> (this is for the new btrfs - btrfsctl shoud do something similar).
> So, as I read it, simply expand (recreate) the partitions (as you say=
ed)
> and use:
> btrfs resize max /dev/sdxY (or something similay in brtfsctl).
>
> But I can't give you a guarantee as I simply interpreted the manpage
> right now and never tried this.
>
> P.s. sorry for my bad english :)
>
> Am 02.05.2010 07:32, schrieb Sebastian 'gonX' Jensen:
>> Hey guys,
>>
>> I kinda figured out the syntax for resizing BTRFS arrays, but is it
>> possible to use free space that is behind the current BTRFS partitio=
n?
>> I kinda figure it's not, but ideally I'd like it so that there is no
>> unused disk space on the disk.
>>
>> My partition setup looks something like this:
>>
>> Partition 1: 100MB (used)
>> Partition 2: 256MB (not used, this is what I want to use)
>> Partition 3: 200GB (used, for BTRFS)
>> Partition 4: 50GB (not used, but this will be expanded to the curren=
t
>> BTRFS partition)
>>
>> Also as a last note (just in case I've misunderstood something), to
>> resize properly, you should first delete the partition using a
>> partition editor like fdisk, then recreate a new partition with the
>> same start cylinders as the original setup, but with bigger/later en=
d
>> cylinders than the original setup, right? Then e.g. btrfsctl -r +45G=
 /
>> What if I have a RAID-0 array (which I do), which uses the RAID-0
>> routine by BTRFS (and not mdraid or dmraid). Should I then do a
>> "btrfsctl -R +(size*disks)G /" or btrfsctl -R +(size of all disks)G
>> /"?
>>
>> Regards,
>> Sebastian J.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
