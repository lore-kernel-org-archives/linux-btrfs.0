From: cwillu <cwillu@cwillu.com>
Subject: Re: [PATCH 0/5] btrfs: snapshot deletion via readahead
Date: Thu, 12 Apr 2012 22:54:15 -0600
Message-ID: <CAE5mzviu=3RPxvDnxV1jCoknSuedhBBSwVe-maF6u4g9j-g5Vw@mail.gmail.com>
References: <cover.1334241664.git.sensille@gmx.net>
	<4F87A034.3030607@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F87A034.3030607@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 9:40 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrot=
e:
> On 04/12/2012 11:54 PM, Arne Jansen wrote:
>> This patchset reimplements snapshot deletion with the help of the re=
adahead
>> framework. For this callbacks are added to the framework. The main i=
dea is
>> to traverse many snapshots at once at read many branches at once. Th=
is way
>> readahead get many requests at once (currently about 50000), giving =
it the
>> chance to order disk accesses properly. On a single disk, the effect=
 is
>> currently spoiled by sync operations that still take place, mainly c=
hecksum
>> deletion. The most benefit can be gained with multiple devices, as a=
ll devices
>> can be fully utilized. It scales quite well with the number of devic=
es.
>> For more details see the commit messages of the individual patches a=
nd the
>> source code comments.
>>
>> How it is tested:
>> I created a test volume using David Sterba's stress-subvol-git-aging=
=2Esh. It
>> checks out randoms version of the kernel git tree, creating a snapsh=
ot from it
>> from time to time and checks out other versions there, and so on. In=
 the end
>> the fs had 80 subvols with various degrees of sharing between them. =
The
>> following tests were conducted on it:
>> =C2=A0- delete a subvol using droptree and check the fs with btrfsck=
 afterwards
>> =C2=A0 =C2=A0for consistency
>> =C2=A0- delete all subvols and verify with btrfs-debug-tree that the=
 extent
>> =C2=A0 =C2=A0allocation tree is clean
>> =C2=A0- delete 70 subvols, and in parallel empty the other 10 with r=
m -rf to get
>> =C2=A0 =C2=A0a good pressure on locking
>> =C2=A0- add various degrees of memory pressure to the previous test =
to get pages
>> =C2=A0 =C2=A0to expire early from page cache
>> =C2=A0- enable all relevant kernel debugging options during all test=
s
>>
>> The performance gain on a single drive was about 20%, on 8 drives ab=
out 600%.
>> It depends vastly on the maximum parallelity of the readahead, that =
is
>> currently hardcoded to about 50000. This number is subject to 2 fact=
ors, the
>> available RAM and the size of the saved state for a commit. As the f=
ull state
>> has to be saved on commit, a large parallelity leads to a large stat=
e.
>>
>> Based on this I'll see if I can add delayed checksum deletions and r=
unning
>> the delayed refs via readahead, to gain a maximum ordering of I/O op=
s.
>>
>
> Hi Arne,
>
> Can you please show us some user cases in this, or can we get some ex=
tra benefits from it? :)
>
> thanks,
> liubo

Expiring old backups routinely takes days to complete due to how long
it takes snapshot deletion to finish.  This makes maximizing the
number of retained backups, or even simply ensuring that we have
enough space for the current backup, quite difficult.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
