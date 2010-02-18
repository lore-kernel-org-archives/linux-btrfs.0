From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 12:46:56 -0800
Message-ID: <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
References: <201002172102.17816.kreijack@libero.it>
	 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
	 <20100218165841.GO10559@think> <201002182100.00624.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002182100.00624.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 11:59 AM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> On Thursday 18 February 2010, Chris Mason wrote:
>> I do like the subcommand method, more details below.
>>
>
> I try to summarise your suggestions. But there are some cases not to =
clear for
> me.
> I grouped the commands in three categories: subvolume, devices, and
> filesystem.
>
>
> devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 scan
> devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 show
> devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 balance
> devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 add
> devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove
>
> subvolume =C2=A0 =C2=A0 =C2=A0 snapshot
> subvolume =C2=A0 =C2=A0 =C2=A0 delete
> subvolume =C2=A0 =C2=A0 =C2=A0 create
> [subvolume =C2=A0 =C2=A0 =C2=A0list]
>
> filesystem =C2=A0 =C2=A0 =C2=A0resize
> [filesystem =C2=A0 =C2=A0 label]
>
> ??? =C2=A0 =C2=A0 defrag
> ??? =C2=A0 =C2=A0 sync
>
>
>
> For the first two categories both Chris and Mike agreed; but IMHO the=
re are
> some commands that don't fit nor in devices, nor subvolume, like resi=
ze (we
> resize a filesystem) and label (not available now).
>

A btrfs filesystem can span multiple devices.  Resize resizes how big
of a chunk of one device btrfs uses.  This would be used by
partitioning programs for instance.  zfs uses the term "pool" instead
of filesystem to solve this ambiguous use of the term "filesystem"
since btrfs and zfs break people's existing definition of the word
"filesystem".

> I don't know how classify defrag (per file / directory level ?) and s=
ync
> (filesystem ?)

It turns out that defrag is per file, which seems most cumbersome.
Maybe since it will probably eventually work against several types of
objects we could have:

btrfs defrag file <file>
btrfs defrag directory <directory>
btrfs defrag subvol <subvol>
btrfs defrag pool <pool>

>
> An option is to consider commands without classification. For example=
s:
>
> $ btrfs subvolume create [path/]<subvolname>
> $ btrfs sync <path>
> $ btrfs defrag <file>

Maybe if the btrfs developers are agreeable, we could do this as well:

btrfs sync file <file>
btrfs sync directory <directory>
btrfs sync subvol <subvol>
btrfs sync pool <pool>

I'm not sure how useful syncing the pool or a directory tree would be,
but I'll include it here for further discussion.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
