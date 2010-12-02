From: Tommy Jonsson <quazzie@gmail.com>
Subject: Re: Fsck, parent transid verify failed
Date: Thu, 2 Dec 2010 23:16:25 +0100
Message-ID: <AANLkTimEHf9tohZ8ZkOiZ-CfTkNgumAFVMsm_FSP9M7S@mail.gmail.com>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
	<1291306826-sup-7837@think>
	<AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com>
	<1291326502-sup-1726@think>
	<AANLkTi=TQ5FeVH2=56kNrdiUNBmSc=dSOwMwcKOVkaTq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=TQ5FeVH2=56kNrdiUNBmSc=dSOwMwcKOVkaTq@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Tried "btrfs-debug-tree /dev/sda" and "btrfs-debug-tree -e /dev/sda" :
parent transid verify failed on 2721514774528 wanted 39651 found 39649
btrfs-debug-tree: disk-io.c:739: open_ctree_fd: Assertion
`!(!tree_root->node)' failed.

dmesg said:
[268375.903581] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 2
transid 39650 /dev/sdd
[268375.904241] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 1
transid 39651 /dev/sdc
[268375.904526] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 3
transid 39651 /dev/sda

-tommy

On Thu, Dec 2, 2010 at 10:59 PM, Tommy Jonsson <quazzie@gmail.com> wrot=
e:
> $ btrfsck -s 1 /dev/sda
> using SB copy 1, bytenr 67108864
> parent transid verify failed on 2721514774528 wanted 39651 found 3964=
9
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)=
' failed.
> Aborted
>
> $ btrfsck -s 2 /dev/sda
> using SB copy 2, bytenr 274877906944
> parent transid verify failed on 2721514774528 wanted 39651 found 3964=
9
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)=
' failed.
> Aborted
>
> -tommy
>
>
> On Thu, Dec 2, 2010 at 10:50 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> Excerpts from Tommy Jonsson's message of 2010-12-02 16:45:39 -0500:
>>> I can't remember if i used -m raid0.
>>> I think i just used "mkfs.btrfs /dev/sda" then "btrfs device add /d=
ev/sdb"
>>> and same for sdc.
>>> I am sure that i didn't explicitly use -m raid1 or raid10.
>>> Is there a way that i can check this ?
>>
>> The defaults will maintain raid1 as you add more drives. =A0We can c=
heck
>> it with btrfs-debug-tree from the git repository. =A0But, more below=
=2E
>>
>>>
>>> If i do have raid0 for both metadata and data is there anything i c=
an do ?
>>> I've been looking at the source but haven't got my head around it y=
et.
>>>
>>> What whould happen if i just ignore/bypass the transid error?
>>>
>>> The error:
>>> [265889.197279] device fsid 734a485d12c77872-9b0b5aa408670db4 devid=
 3
>>> transid 39651 /dev/sda
>>> [265889.198266] btrfs: use compression
>>> [265889.647817] parent transid verify failed on 2721514774528 wante=
d 39651
>>> found 39649
>>> [265889.672632] btrfs: open_ctree failed
>>>
>>> Or could i update the metadata to want 39649 ?
>>
>> The first thing I would try is:
>>
>> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-p=
rogs-unstable.git
>>
>> Build the latest tools, then:
>>
>> btrfsck -s 1 /dev/xxx
>> btrfsck -s 2 /dev/xxx
>>
>> If either of these work we have an easy way to get it mounted. =A0Ju=
st let
>> me know.
>>
>> -chris
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
