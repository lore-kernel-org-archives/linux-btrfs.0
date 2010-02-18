From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 13:39:37 -0800
Message-ID: <93cdabd21002181339i76c38c3ew5f5326e7d034216c@mail.gmail.com>
References: <201002172102.17816.kreijack@libero.it>
	 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
	 <20100218165841.GO10559@think> <201002182100.00624.kreijack@libero.it>
	 <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
	 <20100218205809.GX10559@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Thomas Kupper <thomas@kupper.org>,
	"Di
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100218205809.GX10559@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 12:58 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> On Thu, Feb 18, 2010 at 12:46:56PM -0800, Mike Fedyk wrote:
>> On Thu, Feb 18, 2010 at 11:59 AM, Goffredo Baroncelli
>> <kreijack@gmail.com> wrote:
>> > On Thursday 18 February 2010, Chris Mason wrote:
>> >> I do like the subcommand method, more details below.
>> >>
>> >
>> > I try to summarise your suggestions. But there are some cases not =
to clear for
>> > me.
>> > I grouped the commands in three categories: subvolume, devices, an=
d
>> > filesystem.
>> >
>> >
>> > devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 scan
>> > devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 show
>> > devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 balance
>> > devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 add
>> > devices =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove
>> >
>> > subvolume =C2=A0 =C2=A0 =C2=A0 snapshot
>> > subvolume =C2=A0 =C2=A0 =C2=A0 delete
>> > subvolume =C2=A0 =C2=A0 =C2=A0 create
>> > [subvolume =C2=A0 =C2=A0 =C2=A0list]
>> >
>> > filesystem =C2=A0 =C2=A0 =C2=A0resize
>> > [filesystem =C2=A0 =C2=A0 label]
>> >
>> > ??? =C2=A0 =C2=A0 defrag
>> > ??? =C2=A0 =C2=A0 sync
>> >
>> >
>> >
>> > For the first two categories both Chris and Mike agreed; but IMHO =
there are
>> > some commands that don't fit nor in devices, nor subvolume, like r=
esize (we
>> > resize a filesystem) and label (not available now).
>> >
>>
>> A btrfs filesystem can span multiple devices. =C2=A0Resize resizes h=
ow big
>> of a chunk of one device btrfs uses.
>
> Right, resize is actually always per device. =C2=A0When there is one =
device
> resizing the FS and the device are the same thing.
>
>> This would be used by
>> partitioning programs for instance. =C2=A0zfs uses the term "pool" i=
nstead
>> of filesystem to solve this ambiguous use of the term "filesystem"
>> since btrfs and zfs break people's existing definition of the word
>> "filesystem".
>>
>> > I don't know how classify defrag (per file / directory level ?) an=
d sync
>> > (filesystem ?)
>>
>> It turns out that defrag is per file, which seems most cumbersome.
>> Maybe since it will probably eventually work against several types o=
f
>> objects we could have:
>>
>> btrfs defrag file <file>
>> btrfs defrag directory <directory>
>> btrfs defrag subvol <subvol>
>
> I like these, although we don't currently support the directory/subvo=
l
> side. =C2=A0But we can leave the option open to add these later.
>
>> btrfs defrag pool <pool>
>
> I don't think we'll need defrag pool.
>
>>
>> >
>> > An option is to consider commands without classification. For exam=
ples:
>> >
>> > $ btrfs subvolume create [path/]<subvolname>
>> > $ btrfs sync <path>
>> > $ btrfs defrag <file>
>>
>> Maybe if the btrfs developers are agreeable, we could do this as wel=
l:
>>
>> btrfs sync file <file>
>> btrfs sync directory <directory>
>
> fsync on files and dirs already does this, we don't need a btrfsctl f=
or
> it.
>

How do you fsync a file/dir from a shell script?  Maybe that's a
generic tool that needs to be created...

>> btrfs sync subvol <subvol>
>
> btrfs sync subvol is nice.
>
>> btrfs sync pool <pool>
>>
>
> I don't think we need sync pool.
>

I honestly can't think of a use for it, but I'll bet it'll come in
handy for some weird case while running on top of iscsi or some such
topology.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
