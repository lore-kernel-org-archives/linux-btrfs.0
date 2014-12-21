Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:44944 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbaLUDE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 22:04:57 -0500
Message-ID: <549638D4.60402@pobox.com>
Date: Sat, 20 Dec 2014 19:04:52 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, Daniele Testa <daniele.testa@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com> <54949454.9020601@fb.com>
In-Reply-To: <54949454.9020601@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2014 01:10 PM, Josef Bacik wrote:
> On 12/18/2014 09:59 AM, Daniele Testa wrote:
>> Hey,
>>
>> I am hoping you guys can shed some light on my issue. I know that it's
>> a common question that people see differences in the "disk used" when
>> running different calculations, but I still think that my issue is
>> weird.
>>
>> root@s4 / # mount
>> /dev/md3 on /opt/drives/ssd type btrfs
>> (rw,noatime,compress=zlib,discard,nospace_cache)
>>
>> root@s4 / # btrfs filesystem df /opt/drives/ssd
>> Data: total=407.97GB, used=404.08GB
>> System, DUP: total=8.00MB, used=52.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=1.25GB, used=672.21MB
>> Metadata: total=8.00MB, used=0.00
>>
>> root@s4 /opt/drives/ssd # ls -alhs
>> total 302G
>> 4.0K drwxr-xr-x 1 root         root           42 Dec 18 14:34 .
>> 4.0K drwxr-xr-x 4 libvirt-qemu libvirt-qemu 4.0K Dec 18 14:31 ..
>> 302G -rw-r--r-- 1 libvirt-qemu libvirt-qemu 315G Dec 18 14:49
>> disk_208.img
>>     0 drwxr-xr-x 1 libvirt-qemu libvirt-qemu    0 Dec 18 10:08 snapshots
>>
>> root@s4 /opt/drives/ssd # du -h
>> 0       ./snapshots
>> 302G    .
>>
>> As seen above, I have a 410GB SSD mounted at "/opt/drives/ssd". On
>> that partition, I have one single starse file, taking 302GB of space
>> (max 315GB). The snapshots directory is completely empty.
>>
>> However, for some weird reason, btrfs seems to think it takes 404GB.
>> The big file is a disk that I use in a virtual server and when I write
>> stuff inside that virtual server, the disk-usage of the btrfs
>> partition on the host keeps increasing even if the sparse-file is
>> constant at 302GB. I even have 100GB of "free" disk-space inside that
>> virtual disk-file. Writing 1GB inside the virtual disk-file seems to
>> increase the usage about 4-5GB on the "outside".
>>
>> Does anyone have a clue on what is going on? How can the difference
>> and behaviour be like this when I just have one single file? Is it
>> also normal to have 672MB of metadata for a single file?
>>
>
> Hello and welcome to the wonderful world of btrfs, where COW can really
> suck hard without being super clear why!  It's 4pm on a Friday right
> before I'm gone for 2 weeks so I'm a bit happy and drunk so I'm going to
> use pretty pictures.  You have this case to start with
>
> file offset 0                                               offset 302g
> [-------------------------prealloced 302g extent----------------------]
>
> (man it's impressive I got all that lined up right)
>
> On disk you have 2 things.  First your file which has file extents which
> says
>
> inode 256, file offset 0, size 302g, offset0, disk bytenr 123, disklen 302g
>
> and then in the extent tree, who keeps track of actual allocated space
> has this
>
> extent bytenr 123, len 302g, refs 1
>
> Now say you boot up your virt image and it writes 1 4k block to offset
> 0.  Now you have this
>
> [4k][--------------------302g-4k--------------------------------------]
>
> And for your inode you now have this
>
> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
> disklen 4k
> inode 256, file offset 4k, size 302g-4k, offset 4k, diskbytenr 123,
> disklen 302g
>
> and in your extent tree you have
>
> extent bytenr 123, len 302g, refs 1
> extent bytenr whatever, len 4k, refs 1
>
> See that?  Your file is still the same size, it is still 302g.  If you
> cp'ed it right now it would copy 302g of information.  But what you have
> actually allocated on disk?  Well that's now 302g + 4k.  Now lets say
> your virt thing decides to write to the middle, lets say at offset 12k,
> now you have this
>
> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
> disklen 4k
> inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen 302g
> inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
> disklen 4k
> inode 256, file offset 16k, size 302g - 16k, offset 16k, diskbytenr 123,
> disklen 302g
>
> and in the extent tree you have this
>
> extent bytenr 123, len 302g, refs 2
> extent bytenr whatever, len 4k, refs 1
> extent bytenr notimportant, len 4k, refs 1
>
> See that refs 2 change?  We split the original extent, so we have 2 file
> extents pointing to the same physical extents, so we bumped the ref
> count.  This will happen over and over again until we have completely
> overwritten the original extent, at which point your space usage will go
> back down to ~302g.
>
> We split big extents with cow, so unless you've got lots of space to
> spare or are going to use nodatacow you should probably not pre-allocate
> virt images.  Thanks,

Stll too new to the code base to offer much other than psudocode...

Is it "easy" to find all the inodes that are using a particular extent 
at runtime?

It occurs to me that since every extent starts life with exactly one 
owner, a scruplous breaking of extents can prevent the unbounded 
left-overlap problem...

If the preexisting extent is always broken up into two or three new 
extents wherever it's being referenced, then problematic overlaps are 
eleminated and dead data can be discarded as soon as it's actually dead.

So in the exemplar case
'.' == preexisting extent
'+' == new written extent
'-' == preexisting described by new extent records

The core operations: multiple lines are used because the brackets 
overlap in the ASCII art. 8-)

case 1:
[................]
       [++++]
       [----]
[------]  [------]

case 2:
[................]
             [+++++++++]
             [----]
[------------]

case 3:
      [................]
[+++++++++]
      [----]
          [------------]

case 4: (trivial, extent is just derefed by 1)
       [....]
[++++++++++++++++]


I am going to introduce the word "shatter" for convenience. We will be 
"shattering" the existing extent etc.


So;

Ignoring for a time the existing filesystems with existing problematic 
layouts, which will continue with the (n^2+n)/2 worst case, we can know 
a few things.

For all files, there exists no sliding window over storage. That is 
there is no ioctl() to discard the leading N bytes of a file by just 
moving the various offsets inside the inode-specific reference. Nor is 
there an ioctl to insert data at the front of the file. Both of these 
operations would be "easy" to create in BTRFS, but they do not exist at 
this time.

All users of an extent, not counting theoretical deduplication, follow 
from a single original allocation via reflink, clone, or snapshot.

IFF all extents were always shattered when _any_ file using it had an 
overwrite event THEN all references to extentX would have a reference 
using extent-offest of zero. That is, breaking up extents would result in:

inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever 
disklen same-as-size

So at the time an extent is shattered, iff all the other users of the 
extent can be found easily, a fairly cheap per-inode substitution can be 
computed and performed.


(psudocode)

transaction_start;
foreach existing_extent overlapped by new_extent
do
  new_set peer_uesers = (all referencing inodes but self)
  new_set fragments_other = (empty)
  new_set fragments_self = (empty)
  if (existing.start < overlap.start) then
   left_extent = new_extent_map[existing.start,overlap.start)
   fragments_self += left_extent;
   fragments_other += left_extent;
   left = overlap.start;
  else
   left = existing.start;
  fi
  if (overlap.end < existing.end) then
   right = overlap.end
   right_extent = new_extent_map[overlap.end,existing.end)
   fragments_self += right_extent
   fragments_other += right_extent;
  else
   right = existing.end
  fi
  old_fragment = new_extent_map[left,right)
  if (old_fragment != existing_extent) then
   fragments_other += old_fragment
  fi
  if (not empty(fragments_other) and not_empty(peer_users)) then
   foreach peer_user do
    replace_extent(user,existing_extent,fragments_other)
   done
  replace_extent(self,existing_extent,fragments_self)
done
add_extent(self,new_extent)
transaction_end;

(end pseudocode)


Not optimized (no point in assembling fragments_other if there are no 
peers for example) but it should be logically correct if I didn't make 
some first-year error. 8-)

In practical terms of complexity the leading edge of a new extent can 
either lie on an existing extent boundary or somewhere in the heart of 
an extent. The trailing edge can exist within, uppon, or beyond the end 
of an existing extent. ("beyond the end" being a proper append of a file).

Any extent that is completely spanned by the new extent will get 
dereferenced by replace_extent(self,existing,{0}), e.g. the empty set; 
and skipped over entirely because "fragments_other" would be empty.

Any extent otherwise split will be split everywhere.

The new_extent is never split, so we tend to optimize layout until 
further overwrite.

Deep divergence, such as large extents that should have previously been 
shattered elsewhere just sort of happens when the search for peers 
doesn't have the necessary match to add those inodes into the peer list.

Cost should be manageable since it really only effects zero, one, or two 
existing extents, but cost does scale with the number of peers.
