From: Mike Sampson <mike@sambodata.com>
Subject: Re: Is it possible to reclaim block groups once they are allocated to
 data or metadata?
Date: Sun, 6 May 2012 13:07:06 +1000
Message-ID: <CALzgn9vCcMSEDQXWEwdZJuSeuv9WbK3T=YkQr+y2V=B_-+bWCQ@mail.gmail.com>
References: <CALzgn9tppzTem57mD6ORK7SXCK2vM6hcsWxphdHLr4eNwFTPQg@mail.gmail.com>
	<20120505125238.GJ9860@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Mike Sampson <mike@sambodata.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120505125238.GJ9860@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 5, 2012 at 10:52 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, May 05, 2012 at 10:37:01PM +1000, Mike Sampson wrote:
>> Hello list,
>>
>> recently reformatted my home partition from XFS to RAID1 btrfs. I us=
ed
>> the default options to mkfs.btrfs except for enabling raid1 for data
>> as well as metadata. Filesystem is made up of two 1TB drives.
>>
>> mike@mercury (0) pts/3 ~ $ sudo btrfs filesystem show
>> Label: none =A0uuid: f08a8896-e03e-4064-9b94-9342fb547e47
>> =A0 =A0 =A0 Total devices 2 FS bytes used 888.06GB
>> =A0 =A0 =A0 devid =A0 =A01 size 931.51GB used 931.51GB path /dev/sdb=
1
>> =A0 =A0 =A0 devid =A0 =A02 size 931.51GB used 931.49GB path /dev/sdc=
1
>>
>> Btrfs Btrfs v0.19
>>
>> mike@mercury (0) pts/3 ~ $ btrfs filesystem df /home
>> Data, RAID1: total=3D893.48GB, used=3D886.60GB
>> Data: total=3D8.00MB, used=3D0.00
>> System, RAID1: total=3D8.00MB, used=3D136.00KB
>> System: total=3D4.00MB, used=3D0.00
>> Metadata, RAID1: total=3D38.00GB, used=3D2.54GB
>> Metadata: total=3D8.00MB, used=3D0.00
>>
>> As can be seen I don't have a lot of free space left and while I am
>> planning on adding more storage soon I would like to gain a little
>> breathing room until I can do this. While I don't have a lot of spac=
e
>> remaining in Data, RAID1 I do have a good chunk in Metadata, RAID1.
>> 2.5GB used out of 38GB. Does this excess become available
>> automatically to the file system when the block groups in Data, RAID=
1
>> are exhausted or, if not, is there a way to manually reallocate them=
?
>
> =A0 Youre best bet at the moment is to try a partial balance of
> metadata chunks:
>
> # btrfs balance start -m /home
>
> =A0 That will rewrite all of your metadata, putting it through the
> allocator again, and removing the original allocated chunks. This
> should have the effect of reducing the allocation of metadata chunks.
>
> =A0 You will need a 3.3 kernel, or later, and an up-to-date userspace
> from cmason's git repository.

Gave this a shot and it did help.

mike@mercury (0) pts/3 ~/.../btrfs-progs git:master $ uname -r
3.3.4-2-ARCH

mike@mercury (0) pts/3 ~/.../btrfs-progs git:master $ sudo ./btrfs
balance start -m /home

Done, had to relocate 40 out of 934 chunks

mike@mercury (0) pts/3 ~/.../btrfs-progs git:master $ ./btrfs
filesystem df /home
Data, RAID1: total=3D900.97GB, used=3D880.06GB
Data: total=3D8.00MB, used=3D0.00
System, RAID1: total=3D32.00MB, used=3D136.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D30.50GB, used=3D2.54GB

There is now 8GB less in Metadata and I was able to delete some files
as well to free up space. There is still a lot of wasted space in the
metadata block groups. It seems that it allocates more metadata block
groups than required for my filesystem. This will do until I am able
to add a couple of devices to the system. Is there anyway to adjust
the block group allocation strategy at filesystem creation?

Thanks Hugo,

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
