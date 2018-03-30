Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:46788 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbeC3Err (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 00:47:47 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id DFA0EAC0269
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 13:47:43 +0900 (JST)
Subject: Re: [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call
 "subvolume list/show"
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.com>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
 <7512a9b0-697d-8b5b-9f43-796f211fc5fd@libero.it>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <b44aab69-db62-5adf-e191-9dc3f8cc69f9@jp.fujitsu.com>
Date: Fri, 30 Mar 2018 13:46:46 +0900
MIME-Version: 1.0
In-Reply-To: <7512a9b0-697d-8b5b-9f43-796f211fc5fd@libero.it>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/30 2:35, Goffredo Baroncelli wrote:
> Hi Misono,

Hello,

> 
> I tested you patch, and it seems to work. I verified that the output is correct and the permission check is performed. However the output of "btrfs sub list" in the "root" mode and the "user" mode are a bit different.
> 
> As reported before, I find your output more consistent, and understandable than the original one, which is quite confusing about the sub-volume path relationship. 
> 
> The problem which I am talking is probably due to the fact that I mount a subvolume as root filesystem, and the root-subvolume (the one with ID=5) in a subdirectory (/var/btrfs for what matters).

I didn't think this situation and thanks for pointing out.

Currently this RFC does not care about mounted subvolumes under the specified path.
However, it should be able to search those subvolumes too and list up all the subvolumes
including mounted ones (and below it), by changing progs code.

> 
> I think that the "stock" "btrfs sub list", trying to scan the metadata of btrfs and merging these information with this filesystem layout (composed by different subvolumes mounted in different places) doesn't do a good job.
> 
> The constraints that your API has (the fact that the subvolume has to be accessed by the filesystem), create an output more friendly. Unfortunately this output became again confusing when the command is started by root.
> 
> [Un]fortunately, the stock "btrfs sub list" has the capability to show all the subvolumes, even the ones not mounted, so this can be entirely replaced by your API.
> 
> My conclusion, is that your work is not consistent with the current implementation; so I am suggesting to create a new subcommand ("btrfs sub tree" ?) where you can use, without constraint, your api.

I agree that the current output of "sub list" is confusing first of all and
it is not easy to keep consistent behavior between user and root.

So, I think "sub list" (or new command) should be:
  - (default) list the subvolumes under the specified path, including subvolumes mounted below the specified path.
              Any user can do this (with appropriate permission checks).
              The path to be printed is the relative from the specified path.
  - (-a option) list all the subvolmumes in the filesystem. Only root can do this.
              The path to be printed is the absolute path from the toplevel subvolume.

This would need some changes in progs code, but I think we can use the same new ioctls I proposed[1] for the default behavior.

I'd like to update "sub list" command eventually rather than adding new command, even though this breaks the compatibility.
I want to know what other developer/user think.

[1] https://www.spinics.net/lists/linux-btrfs/msg76003.html

> 
> Another small differences that I found is in the subcommand "btrfs sub show". This is not capable to show the snapshots of a subvolume; I think that, in "user mode", it should be reported that there is a "missing capabilities" problem than to show an empty list

Yes, this is because that only the snapshots *under the specified path* are searched.
This can be easily changed to search under the mount point, but this also results in
slight change in print format of the path for root. I tried to keep as much consistency in this version.

Thanks,
Tomohiro Misono

> 
> Below an example of what I am say:
> 
> ghigo@venice:/tmp$ btrfs sub cre a
> ghigo@venice:/tmp$ btrfs sub snap a c
> 
> ghigo@venice:/tmp$ # patched btrfs
> ghigo@venice:/tmp$ /home/ghigo/btrfs/btrfs-progs/btrfs sub show a
> tmp/a
> 	Name: 			a
> 	UUID: 			0c19a7a4-a7f5-1849-9262-88ab3da504d0
> 	Parent UUID: 		-
> 	Received UUID: 		-
> 	Creation time: 		2018-03-28 22:48:09 +0200
> 	Subvolume ID: 		598
> 	Generation: 		696908
> 	Gen at creation: 	696907
> 	Parent ID: 		257
> 	Top level ID: 		257
> 	Flags: 			-
> 	Snapshot(s):
>                             ^^^^^^^^^^^^^^^^^^^^
> 
> ghigo@venice:/tmp$ # stock btrfs
> ghigo@venice:/tmp$ sudo /home/ghigo/btrfs/btrfs-progs/btrfs sub show a
>                   ^^^^^^
> tmp/a
> 	Name: 			a
> 	UUID: 			0c19a7a4-a7f5-1849-9262-88ab3da504d0
> 	Parent UUID: 		-
> 	Received UUID: 		-
> 	Creation time: 		2018-03-28 22:48:09 +0200
> 	Subvolume ID: 		598
> 	Generation: 		696908
> 	Gen at creation: 	696907
> 	Parent ID: 		257
> 	Top level ID: 		257
> 	Flags: 			-
> 	Snapshot(s):
> 				debian/tmp/c
>                                 ^^^^^^^^^^^^^
>                                
> 
> BR
> G.Baroncelli
> 
> 
> -----
> Test performed:
> 
> ghigo@venice:/tmp$ sudo btrfs sub crea a
> ghigo@venice:/tmp$ sudo btrfs sub crea a/a1
> ghigo@venice:/tmp$ sudo btrfs sub crea a/a1/a2
> ghigo@venice:/tmp$ sudo btrfs sub crea b
> ghigo@venice:/tmp$ sudo btrfs sub crea b/b1
> ghigo@venice:/tmp$ sudo chmod og-rwx b/.
> 
> 
> # stock btrfs progs
> ghigo@venice:/tmp$ sudo btrfs sub l .
> ID 257 gen 696886 top level 5 path debian
> ID 289 gen 587461 top level 257 path var/lib/machines
> ID 299 gen 693561 top level 5 path boot
> ID 582 gen 683965 top level 5 path i386
> ID 592 gen 696884 top level 257 path tmp/a
> ID 593 gen 696885 top level 592 path tmp/a/a1
> ID 594 gen 696885 top level 593 path tmp/a/a1/a2
> ID 595 gen 696887 top level 257 path tmp/b
> ID 596 gen 696887 top level 595 path tmp/b/b1
> 
> # patched btrfs progs
> ghigo@venice:/tmp$ /home/ghigo/btrfs/btrfs-progs/btrfs sub lis .
> ID 592 gen 696884 top level 257 path a
> ID 593 gen 696885 top level 592 path a/a1
> ID 594 gen 696885 top level 593 path a/a1/a2
> ID 595 gen 0 top level 257 path b
> 
> 
> ghigo@venice:/tmp$ /home/ghigo/btrfs/btrfs-progs/btrfs sub show a
> tmp/a
> 	Name: 			a
> 	UUID: 			17520c11-ec8b-5b49-a07e-37ba58113261
> 	Parent UUID: 		-
> 	Received UUID: 		-
> 	Creation time: 		2018-03-28 22:19:48 +0200
> 	Subvolume ID: 		592
> 	Generation: 		696884
> 	Gen at creation: 	696883
> 	Parent ID: 		257
> 	Top level ID: 		257
> 	Flags: 			-
> 	Snapshot(s):
> 
> 
> On 03/19/2018 08:30 AM, Misono, Tomohiro wrote:
>> changelog:
>>
>> v2 -> v3
>>   - use get_euid() to check the caller's privilege (and remove 3rd patch)
>>   - improve error handling
>> v1 -> v2
>>   - add independent error handling patch (1st patch)
>>   - reimplement according to ioctl change
>>   - various cleanup
>> ===
>>
>> This RFC implements user version of "subvolume list/show" using three new ioctls.
>> The ioctl patch to the kernel can be found in the ML titled 
>>   "[PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow normal users to call "sub list/show" etc.
>>
>> 1th patch is independent and improvements of error handling
>> 2nd-4th are some prepartion works.
>> 5th patch is the main part.
>> 6th-7th adds the test for "subvolume list"
>>
>> The main behavior differences between root and normal users are:
>>
>> - "sub list" list the subvolumes which exist under the specified path 
>> (including the path itself). The specified path itself is not needed to be
>>  a subvolume. Also If the subvolume cannot be opend but the parent
>> directory can be, the information other than name or id would be zeroed out.
>>
>> - snapshot filed of "subvolume show" just lists
>> the snapshots under the specified subvolume.
>>
>>
>> This is a part of RFC I sent last December[1] whose aim is to improve normal users' usability.
>> The remaining works of RFC are: 
>>   - Allow "sub delete" for empty subvolume
>>   - Allow "qgroup show" to check quota limit
>>
>> [1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70991.html
>>
>>
>> Tomohiro Misono (7):
>>   btrfs-progs: sub list: Call rb_free_nodes() in error path
>>   btrfs-progs: ioctl: Add 3 definitions of new unprivileged ioctl
>>   btrfs-progs: sub list: Pass specified path down to
>>     btrfs_list_subvols()
>>   btrfs-progs: fallback to open without O_NOATIME flag in
>>     find_mount_root()
>>   btrfs-progs: sub list: Allow normal user to call "subvolume list/show"
>>   btrfs-progs: test: Add helper function to check if test user exists
>>   btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
>>     root and normal user
>>
>>  btrfs-list.c                               | 376 +++++++++++++++++++++++++++--
>>  btrfs-list.h                               |   7 +-
>>  cmds-subvolume.c                           |  14 +-
>>  ioctl.h                                    |  86 +++++++
>>  tests/cli-tests/009-subvolume-list/test.sh | 136 +++++++++++
>>  tests/common                               |  10 +
>>  utils.c                                    |  13 +-
>>  7 files changed, 609 insertions(+), 33 deletions(-)
>>  create mode 100755 tests/cli-tests/009-subvolume-list/test.sh
>>
> 
> 

