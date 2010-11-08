From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Questions regarding COW-related behaviors
Date: Mon, 8 Nov 2010 14:23:13 +0000
Message-ID: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list.


I've been working on my MSc thesis and I believe such a time came when =
it will cross paths with BTRFS.

However, I have a couple of standing questions I haven't been able do a=
nswer, even though having read Ohad Rodeh's paper, most of the wiki's d=
ocumentation, after looking to BTRFS' code and after testing it myself =
--- I'm not putting aside missing some information, somewhere, though.

Basically, I need to be aware how the COW works in BTRFS, and what it m=
ay allow one to achieve. Questions follow.

1) Is COW only used when creating or updating a file? While testing BTR=
=46S, using 'btrfs subvolume find-new', I got the idea that neither cre=
ation of directories, nor any kind of deletion are covered by COW. Is t=
his right?

2) Each time a COW happens, is there any kind implicit 'snapshotting' t=
hat may keep track of changes around the filesystem for each COW?=20
By Rodeh's paper and some info on the wiki, I gather that a new root is=
 created for each COW, due to shadowing, but will the previous tree be =
kept? The wiki, at "BTRFS Design", states that "after the commit finish=
es, the older subvolume root items may be removed". This would make imp=
ossible to track changes to files, but 'btrfs subvolume find-new' still=
 manages to output file generations, so there must be some info left be=
hind.=20

3) Following (2), is there any way to access this informations and, let=
's say, recover an older version of a given file? Or an entire previous=
 tree?

4) From Rodeh's paper I got the idea that BTRFS uses periodic checkpoin=
ting, in order to assign generations to operations. Using 'btrfs subvol=
ume find-new' I confirmed my suspicions. After copying two different di=
rectories into the same subvolume at the same time, all files got assig=
ned the same generation and it took a while until they all showed up. T=
his raises the question: what triggers a new checkpoint? Is it based on=
 elapsed time since last checkpoint? Is it triggered by a COW and then,=
 all COWs happening at the same time will be put together and create a =
big new generation?

5) If we have multiple jobs updating the same file at the same time, I =
assume the system will shadow their updates; when the time for committi=
ng comes, will there be any kind of 'conflict' between concurrent updat=
es, or will they be applied by order of commit, ignoring whether there =
were previous commits or not? Regarding checkpointing, will all the cha=
nges be shown as part of the generation, or will they be considered as =
only one?


I would greatly appreciate any answer regarding any of this topics, inc=
luding any pointers to additional documentation that I may have missed.


Regards.


---
Jo=E3o Eduardo Lu=EDs




--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
