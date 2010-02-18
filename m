From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 11:45:31 +0200
Message-ID: <4B7D0C3B.1090503@cs.bgu.ac.il>
References: <201002172102.17816.kreijack@libero.it> <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


 Hi,
I agree with Mike, it's just much much more pleasant and intuitive to
work with the hierarchyial cli he suggests.

Alex
=20
Mike Fedyk wrote:
> I think he need some command hierarchy here.
>
> On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
>  =20
>> OPTIONS
>>       snapshot|-s <source> [<dest>/]<name>
>>              Create a writeble snapshot of the subvolume  <source>  =
with  the
>>              name  <name>  in the <dest> directory. If <source> is n=
ot a sub=E2=80=90
>>              volume, btrfs returns an error.
>>    =20
>
> This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
> It only works on subvolumes.
>
>  =20
>>       delete|-D <subvolume>
>>              Delete the subvolume <subvolume>. If <subvolume> is not=
  a  sub=E2=80=90
>>              volume, btrfs returns an error.
>>
>>    =20
>
> This becomes:
>
> btrfs subvolume delete <subvolume>
>
> This works with snapshots as well.
>
>  =20
>>       subvolume|-c [<dest>/]<name>
>>              Create  a  subvolume  in  <dest> (or in the current dir=
ectory if
>>              <dest> is not passed).
>>    =20
>
> btrfs subvolume create [<dest>/]<name>
>
>  =20
>>       defrag|-f <file>|<dir> [<file>|<dir>...]
>>              Defragment files and/or directories.
>>    =20
>
> This will defrag individual files?  Does it defrag a directory tree?
> Does it defrag a subvolume?  Does it defrag a pool?
>
>  =20
>>       scan|-n [<device> [<device>..]]
>>              Scan devices for a btrfs filesystem. If no devices  are=
  passed,
>>              btrfs scans all the block devices.
>>    =20
>
> btrfs pool scan [<device> [<device>..]]
>
>  =20
>>       fssync|-y <path>
>>              Force a sync for the filesystem identified by <path>.
>>
>>    =20
>
> Does it sync a pool or subvolume?  Assuming it works against
> subvolumes, it would be:
>
> btrfs subvolume sync <path>
>
>  =20
>>       resize|-z [+/-]<size>[gkm]|max <filesystem>
>>              Resize a file system identified by <path>.  The <size> =
parameter
>>              specifies the new size of the filesystem.  If the prefi=
x + or  -
>>              is  present  the  size is increased or decreased by the=
 quantity
>>              <size>.  If no units are  specified,  the  unit  of  th=
e  <size>
>>              parameter  is  the  byte.  Optionally, the size paramet=
er may be
>>              suffixed by one of the following  the  units  designato=
rs:  'K',
>>              'M', or 'G', kilobytes, megabytes, or gigabytes, respec=
tively.
>>
>>              If  'max'  is  passed,  the filesystem will occupy all =
available
>>              space on the volume(s).
>>
>>              The resize command does not manipulate the  size  of  u=
nderlying
>>              partitions.   If  you  wish  to enlarge/reduce a filesy=
stem, you
>>              must make sure you can expand/reduce the size of  the  =
partition
>>              also.
>>
>>    =20
>
> This works with physical devices, not a pool or subvolume.  I get the
> name "physical volume" from lvm.  Also I think it should resize to ma=
x
> without arguments, in order to do that, the size argument would need
> to be the last argument.
>
> It becomes:
>
> btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>
>
> Or:
>
> btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]
>
>  =20
>>       show|-l [<dev>|<label>...]
>>              Show  the btrfs devices with some additional info. If n=
o devices
>>              or labels are passed, btrfs scans all the block devices=
=2E
>>    =20
>
> This becomes:
>
> btrfs pool show [<dev>|<label>...]
>
>  =20
>>       balance|-b <path>
>>              Balance the chunk of the filesystem identified by <path=
>  across
>>              the devices.
>>    =20
>
> Is path to one of the block devices in the pool?
>
> This becomes:
>
> btrfs pool balance <path>
>
>  =20
>>       add-dev|-A  <dev> [<dev>..] <path>
>>              Add device(s) to the filesystem identified by <path>.
>>    =20
>
> What is path?  Somewhere the pool is mounted?  The root of where the
> pool is mounted?
>
> this becomes:
>
> btrfs pvolume add <dev> [<dev>..] <path>
>
>  =20
>>       rm-dev|-R  <dev> [<dev>..] <path>
>>              Remove device(s) to the filesystem identified by <path>=
=2E
>>    =20
>
> (same questions as with add)
>
> This becomes:
>
> btrfs pvolume remove <dev> [<dev>..] <path>
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
