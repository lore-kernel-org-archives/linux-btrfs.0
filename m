Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:59304 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754206AbdCHVRg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 16:17:36 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, anand.jain@oracle.com,
        kilobyte@angband.pl, demfloro@demfloro.ru
From: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <9110483f-e11e-ea7b-5ef0-fd87b6a84429@libero.it>
Date: Wed, 8 Mar 2017 22:08:06 +0100
MIME-Version: 1.0
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I made some tests (see table below). Basically I created a hybrid btrfs filesystem composed by a metadata "single" profile, and a data single/raid1/raid10/raid5/raid6 profile.

For each test case I tried to remove a disk (which could be used by data and or metadata), and then I checked if the filesystem was mountable.

The results were alway the ones expected: when the number of the disks was insufficient, btrfs refused to mount the filesystem. Otherwise of the mount was fine with the correct info in dmesg (with the exception if I remove a disks with the system chunk of course). The hybrid profiles ensure that btrfs checks all the chunks.

The only exception was for raid10. If I remove 2 disks the filesystem were always unmountable. I tried all the combinations and none was successful. But I suppose that some could be OK: i.e. the ones where I removed each half of raid1. This could be a possible future improvement.

Finally a little suggestion: the message showed in dmesg is something like

"chunk 20971520 missing 3 devices, max tolerance is 2 for writable mount"

I suggest 

"chunk 20971520 (RAID6/6 disks) missing 3 devices, max allowed 2 for a successful mount"

1) "max tolerance is 2" is not very clear for me (but I have to admit my English is terrific :-) )
2) the message seems to suggest that a non-writable mount could be allowed: is it the case ?
3) add (if possible) the raid profile and the number of disks, this could help the diagnosis

Anyway thanks for your effort on the multi-disk support.

BR
G.Baroncelli


Test report:

Data	Metadata	Nr disk	Test	     			ExRes	Res
----    --------	-------	-------------------		-----	----
SINGLE 	SINGLE 		4	Remove  mdata disk       	No 	Yes
SINGLE 	SINGLE 		4	Remove  unused disk       	yes	Yes
SINGLE 	SINGLE 		4	Remove  data disk       	No 	Yes
					
RAID1  	SINGLE 		4	Remove  mdata disk       	No 	yes
RAID1  	SINGLE 		4	Remove  data disk       	Yes	yes
RAID1  	SINGLE 		5	Remove  unused  disk       	yes	yes
RAID1  	SINGLE 		5	Remove  data disk  (2)		No 	yes
					
RAID10 	SINGLE 		5	Remove  mdata disk       	No 	yes
RAID10 	SINGLE 		5	Remove  data disk       	Yes	yes
RAID10 	SINGLE 		5	Remove  data disk  (2)		No 	Yes (*)
					
RAID5  	SINGLE 		5	Remove  mdata disk       	No 	yes
RAID5  	SINGLE 		5	Remove  data disk       	Yes	yes
RAID5  	SINGLE 		5	Remove  data disk  (2)		No 	yes
					
RAID6  	SINGLE 		5	Remove  mdata disk       	No 	yes
RAID6  	SINGLE 		5	Remove  data disk  		Yes	yes
RAID6  	SINGLE 		5	Remove  data disk  (2)		Yes	yes
RAID6  	SINGLE 		5	Remove  data disk  (3)		No 	yes
					
					
Note:					
ExRes: Expected result	      -> expectet mount success
Res: Result		      -> test result
Remove mdata disk             -> remove the disk which holds metadata					
Remove  data disk             -> remove the disk which holds data 
				 (and not metadata)					
Remove  data disk (2)         -> remove 2 disks which hold data (and not
 				 metadata) 
Remove  data disk (3)         -> remove 3 disks which hold data (and not
 				 metadata) 
Removed unused disk           -> removed an unused disk					




On 2017-03-08 03:41, Qu Wenruo wrote:
> Btrfs currently uses num_tolerated_disk_barrier_failures to do global
> check for tolerated missing device.
> 
> Although the one-size-fit-all solution is quite safe, it's too strict
> if data and metadata has different duplication level.
> 
> For example, if one use Single data and RAID1 metadata for 2 disks, it
> means any missing device will make the fs unable to be degraded
> mounted.
> 
> But in fact, some times all single chunks may be in the existing
> device and in that case, we should allow it to be rw degraded mounted.



> 
> Such case can be easily reproduced using the following script:
>  # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
>  # wipefs -f /dev/sdc
>  # mount /dev/sdb -o degraded,rw
> 
> If using btrfs-debug-tree to check /dev/sdb, one should find that the
> data chunk is only in sdb, so in fact it should allow degraded mount.
> 
> This patchset will introduce a new per-chunk degradable check for
> btrfs, allow above case to succeed, and it's quite small anyway.
> 
> And enhance kernel error message for missing device, at least kernel
> can know what's making mount failed, other than meaningless
> "failed to read system chunk/chunk tree -5".
> 
> v2:
>   Update after almost 2 years.
>   Add the last patch to enhance the kernel output, so user can know
>   it's missing devices prevent btrfs to mount.
> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in btrfs_device,
>   but use a new structure extra_rw_degrade_errors, to record error when
>   sending down/waiting device.
> 
> Sorry Dmitrii Tcvetkov and Adam Borowski, I'm afraid I can't add your
> tested-by tags in v3, as the 4th and 4th patches have quite a big change,
> so you may need to retest the new patchset.
> Sorry for the trouble.
> 
> Qu Wenruo (7):
>   btrfs: Introduce a function to check if all chunks a OK for degraded
>     rw mount
>   btrfs: Do chunk level rw degrade check at mount time
>   btrfs: Do chunk level degradation check for remount
>   btrfs: Introduce extra_rw_degrade_errors parameter for
>     btrfs_check_rw_degradable
>   btrfs: Allow barrier_all_devices to do chunk level device check
>   btrfs: Cleanup num_tolerated_disk_barrier_failures
>   btrfs: Enhance missing device kernel message
> 
>  fs/btrfs/ctree.h   |   2 -
>  fs/btrfs/disk-io.c |  87 ++++++------------------------
>  fs/btrfs/disk-io.h |   2 -
>  fs/btrfs/super.c   |   5 +-
>  fs/btrfs/volumes.c | 156 ++++++++++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/volumes.h |  37 +++++++++++++
>  6 files changed, 188 insertions(+), 101 deletions(-)
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
