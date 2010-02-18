From: Thomas Kupper <thomas@kupper.org>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 19:20:20 +0100
Message-ID: <E6160DF1-21CD-4CC8-943D-29300CB3251A@kupper.org>
References: <201002172102.17816.kreijack@libero.it> <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com> <20100218165841.GO10559@think> <93cdabd21002180958s39dc91a1i32fee77f6ea051b@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=utf-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002180958s39dc91a1i32fee77f6ea051b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I'm happy that I'm not alone with my preference for subcommands :) over=
 short -<one-letter> commands.

Btw: I think it would be a good idea start from the beginning with a 'l=
ibbtrfs' library and a corresponding API. That way integrating into oth=
er languages like Python and integration into tools like parted (or lib=
parted) would be quite easy.


On 18 Feb 2010, at 18:58, Mike Fedyk wrote:

> On Thu, Feb 18, 2010 at 8:58 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> I do like the subcommand method, more details below.
>>=20
>> On Wed, Feb 17, 2010 at 03:35:26PM -0800, Mike Fedyk wrote:
>>> I think he need some command hierarchy here.
>>>=20
>>> On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
>>> <kreijack@gmail.com> wrote:
>>>> OPTIONS
>>>>       snapshot|-s <source> [<dest>/]<name>
>>>>              Create a writeble snapshot of the subvolume  <source>=
  with  the
>>>>              name  <name>  in the <dest> directory. If <source> is=
 not a sub=E2=80=90
>>>>              volume, btrfs returns an error.
>>>=20
>>> This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
>>> It only works on subvolumes.
>>=20
>> If we can type subvol instead of subvolume I like it.  Basically the
>> perl/python arg parsing system where any short form of the command t=
hat
>> uniquely matches it is allowed.
>>=20
>> We keep the long forms but allow the user to pick a shorter form if =
it
>> isn't ambiguous.
>>=20
>=20
> Yes, I agree.  This is why I compared it with the ip command which
> does the same.
>=20
>>>=20
>>>>=20
>>>>=20
>>>>       delete|-D <subvolume>
>>>>              Delete the subvolume <subvolume>. If <subvolume> is n=
ot  a  sub=E2=80=90
>>>>              volume, btrfs returns an error.
>>>>=20
>>>=20
>>> This becomes:
>>>=20
>>> btrfs subvolume delete <subvolume>
>>=20
>> subvol del (same as above).
>>=20
>>>=20
>>> This works with snapshots as well.
>>>=20
>>>>=20
>>>>       subvolume|-c [<dest>/]<name>
>>>>              Create  a  subvolume  in  <dest> (or in the current d=
irectory if
>>>>              <dest> is not passed).
>>>=20
>>> btrfs subvolume create [<dest>/]<name>
>>>=20
>>>>=20
>>>>=20
>>>>       defrag|-f <file>|<dir> [<file>|<dir>...]
>>>>              Defragment files and/or directories.
>>>=20
>>> This will defrag individual files?  Does it defrag a directory tree=
?
>>> Does it defrag a subvolume?  Does it defrag a pool?
>>=20
>> For now lets change this to only do files.  That's the only thing th=
e
>> tool supports today.
>>=20
>>>=20
>>>>=20
>>>>=20
>>>>       scan|-n [<device> [<device>..]]
>>>>              Scan devices for a btrfs filesystem. If no devices  a=
re  passed,
>>>>              btrfs scans all the block devices.
>>>=20
>>> btrfs pool scan [<device> [<device>..]]
>>=20
>> Instead of btrfs pool, please use btrfs dev
>>=20
>>>=20
>>>>=20
>>>>=20
>>>>       fssync|-y <path>
>>>>              Force a sync for the filesystem identified by <path>.
>>>>=20
>>>=20
>>> Does it sync a pool or subvolume?  Assuming it works against
>>> subvolumes, it would be:
>>>=20
>>> btrfs subvolume sync <path>
>>>=20
>>>>=20
>>>>=20
>>>>       resize|-z [+/-]<size>[gkm]|max <filesystem>
>>>>              Resize a file system identified by <path>.  The <size=
> parameter
>>>>              specifies the new size of the filesystem.  If the pre=
fix + or  -
>>>>              is  present  the  size is increased or decreased by t=
he quantity
>>>>              <size>.  If no units are  specified,  the  unit  of  =
the  <size>
>>>>              parameter  is  the  byte.  Optionally, the size param=
eter may be
>>>>              suffixed by one of the following  the  units  designa=
tors:  'K',
>>>>              'M', or 'G', kilobytes, megabytes, or gigabytes, resp=
ectively.
>>>>=20
>>>>              If  'max'  is  passed,  the filesystem will occupy al=
l available
>>>>              space on the volume(s).
>>>>=20
>>>>              The resize command does not manipulate the  size  of =
 underlying
>>>>              partitions.   If  you  wish  to enlarge/reduce a file=
system, you
>>>>              must make sure you can expand/reduce the size of  the=
  partition
>>>>              also.
>>>>=20
>>>=20
>>> This works with physical devices, not a pool or subvolume.  I get t=
he
>>> name "physical volume" from lvm.  Also I think it should resize to =
max
>>> without arguments, in order to do that, the size argument would nee=
d
>>> to be the last argument.
>>=20
>> We don't have physical volumes and logical volumes the way lvm does,=
 so
>> I'd like to avoid the pvolume theme.
>>=20
>>>=20
>>> It becomes:
>>>=20
>>> btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>
>>>=20
>>> Or:
>>>=20
>>> btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]
>>=20
>> btrfs dev resize
>>=20
>=20
> Dev works for me, I could only think of the lvm terms at the time.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
