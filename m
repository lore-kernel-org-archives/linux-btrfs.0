From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 09:58:18 -0800
Message-ID: <93cdabd21002180958s39dc91a1i32fee77f6ea051b@mail.gmail.com>
References: <201002172102.17816.kreijack@libero.it>
	 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
	 <20100218165841.GO10559@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Thomas Kupper <thomas@kupper.org>,
	"Di
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100218165841.GO10559@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 8:58 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> I do like the subcommand method, more details below.
>
> On Wed, Feb 17, 2010 at 03:35:26PM -0800, Mike Fedyk wrote:
>> I think he need some command hierarchy here.
>>
>> On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
>> <kreijack@gmail.com> wrote:
>> > OPTIONS
>> > =C2=A0 =C2=A0 =C2=A0 snapshot|-s <source> [<dest>/]<name>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a writeble =
snapshot of the subvolume =C2=A0<source> =C2=A0with =C2=A0the
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name =C2=A0<name> =
=C2=A0in the <dest> directory. If <source> is not a sub=E2=80=90
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs retu=
rns an error.
>>
>> This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
>> It only works on subvolumes.
>
> If we can type subvol instead of subvolume I like it. =C2=A0Basically=
 the
> perl/python arg parsing system where any short form of the command th=
at
> uniquely matches it is allowed.
>
> We keep the long forms but allow the user to pick a shorter form if i=
t
> isn't ambiguous.
>

Yes, I agree.  This is why I compared it with the ip command which
does the same.

>>
>> >
>> >
>> > =C2=A0 =C2=A0 =C2=A0 delete|-D <subvolume>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the subvolu=
me <subvolume>. If <subvolume> is not =C2=A0a =C2=A0sub=E2=80=90
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs retu=
rns an error.
>> >
>>
>> This becomes:
>>
>> btrfs subvolume delete <subvolume>
>
> subvol del (same as above).
>
>>
>> This works with snapshots as well.
>>
>> >
>> > =C2=A0 =C2=A0 =C2=A0 subvolume|-c [<dest>/]<name>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create =C2=A0a =C2=
=A0subvolume =C2=A0in =C2=A0<dest> (or in the current directory if
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<dest> is not pass=
ed).
>>
>> btrfs subvolume create [<dest>/]<name>
>>
>> >
>> >
>> > =C2=A0 =C2=A0 =C2=A0 defrag|-f <file>|<dir> [<file>|<dir>...]
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment files a=
nd/or directories.
>>
>> This will defrag individual files? =C2=A0Does it defrag a directory =
tree?
>> Does it defrag a subvolume? =C2=A0Does it defrag a pool?
>
> For now lets change this to only do files. =C2=A0That's the only thin=
g the
> tool supports today.
>
>>
>> >
>> >
>> > =C2=A0 =C2=A0 =C2=A0 scan|-n [<device> [<device>..]]
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Scan devices for a=
 btrfs filesystem. If no devices =C2=A0are =C2=A0passed,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs scans all th=
e block devices.
>>
>> btrfs pool scan [<device> [<device>..]]
>
> Instead of btrfs pool, please use btrfs dev
>
>>
>> >
>> >
>> > =C2=A0 =C2=A0 =C2=A0 fssync|-y <path>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Force a sync for t=
he filesystem identified by <path>.
>> >
>>
>> Does it sync a pool or subvolume? =C2=A0Assuming it works against
>> subvolumes, it would be:
>>
>> btrfs subvolume sync <path>
>>
>> >
>> >
>> > =C2=A0 =C2=A0 =C2=A0 resize|-z [+/-]<size>[gkm]|max <filesystem>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize a file syst=
em identified by <path>. =C2=A0The <size> parameter
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specifies the new =
size of the filesystem. =C2=A0If the prefix + or =C2=A0-
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is =C2=A0present =C2=
=A0the =C2=A0size is increased or decreased by the quantity
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size>. =C2=A0If n=
o units are =C2=A0specified, =C2=A0the =C2=A0unit =C2=A0of =C2=A0the =C2=
=A0<size>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parameter =C2=A0is=
 =C2=A0the =C2=A0byte. =C2=A0Optionally, the size parameter may be
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0suffixed by one of=
 the following =C2=A0the =C2=A0units =C2=A0designators: =C2=A0'K',
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0'M', or 'G', kilob=
ytes, megabytes, or gigabytes, respectively.
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If =C2=A0'max' =C2=
=A0is =C2=A0passed, =C2=A0the filesystem will occupy all available
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volum=
e(s).
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command=
 does not manipulate the =C2=A0size =C2=A0of =C2=A0underlying
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions. =C2=A0=
 If =C2=A0you =C2=A0wish =C2=A0to enlarge/reduce a filesystem, you
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0must make sure you=
 can expand/reduce the size of =C2=A0the =C2=A0partition
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0also.
>> >
>>
>> This works with physical devices, not a pool or subvolume. =C2=A0I g=
et the
>> name "physical volume" from lvm. =C2=A0Also I think it should resize=
 to max
>> without arguments, in order to do that, the size argument would need
>> to be the last argument.
>
> We don't have physical volumes and logical volumes the way lvm does, =
so
> I'd like to avoid the pvolume theme.
>
>>
>> It becomes:
>>
>> btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>
>>
>> Or:
>>
>> btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]
>
> btrfs dev resize
>

Dev works for me, I could only think of the lvm terms at the time.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
