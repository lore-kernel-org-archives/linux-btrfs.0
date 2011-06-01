From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [3.0-rc1] kernel BUG at fs/btrfs/relocation.c:4285!
Date: Wed, 01 Jun 2011 19:44:27 +0900
Message-ID: <4DE6180B.5050005@jp.fujitsu.com>
References: <4DE43607.2090105@jp.fujitsu.com> <4DE5EDF0.4030601@cn.fujitsu.com> <4DE5F450.9000506@cn.fujitsu.com> <4DE60999.4000208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE60999.4000208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, liubo,

(2011/06/01 18:42), liubo wrote:
> On 06/01/2011 04:12 PM, liubo wrote:
>> On 06/01/2011 03:44 PM, liubo wrote:
>>>> On 05/31/2011 08:27 AM, Tsutomu Itoh wrote:
>>>>>>>> The panic occurred when 'btrfs fi bal /test5' was executed.
>>>>>>>>
>>>>>>>> /test5 is as follows:
>>>>>>>> # mount -o space_cache,compress=lzo /dev/sdc3 /test5
>>>>>>>> #
>>>>>>>> # btrfs fi sh /dev/sdc3
>>>>>>>> Label: none  uuid: 38ec48b2-a64b-4225-8cc6-5eb08024dc64
>>>>>>>>          Total devices 5 FS bytes used 7.87MB
>>>>>>>>          devid    1 size 10.00GB used 2.02GB path /dev/sdc3
>>>>>>>>          devid    2 size 15.01GB used 3.00GB path /dev/sdc5
>>>>>>>>          devid    3 size 15.01GB used 3.00GB path /dev/sdc6
>>>>>>>>          devid    4 size 20.01GB used 2.01GB path /dev/sdc7
>>>>>>>>          devid    5 size 10.00GB used 2.01GB path /dev/sdc8
>>>>>>>>
>>>>>>>> Btrfs v0.19-50-ge6bd18d
>>>>>>>> # btrfs fi df /test5
>>>>>>>> Data, RAID0: total=10.00GB, used=3.52MB
>>>>>>>> Data: total=8.00MB, used=1.60MB
>>>>>>>> System, RAID1: total=8.00MB, used=4.00KB
>>>>>>>> System: total=4.00MB, used=0.00
>>>>>>>> Metadata, RAID1: total=1.00GB, used=216.00KB
>>>>>>>> Metadata: total=8.00MB, used=0.00
>>>>>>>>
>>>>
>>>> Hi, Itoh san,
>>>>
>>>> I've come up with a patch aiming to fix this bug.
>>>> The problems is that the inode allocator stores one inode cache per root,
>>>> which is at least not good for relocation tree, cause we only find
>>>> new inode number from fs tree or file tree (subvol/snapshot).
>>>>
>>>> I've tested with your run.sh and it works well on my box, so you can try this:
>>>>
> 
> I've tested the following patch for about 1.5 hour, and nothing happened.
> And would you please test this patch?

Thank you for your investigation.

I will also test again. but, I cannot test until next week because I
will go to LinuxCon tomorrow and the day after tomorrow.

Thanks,
Tsutomu


> 
> thanks,
> 
> From: Liu Bo<liubo2009@cn.fujitsu.com>
> 
> [PATCH] Btrfs: fix save ino cache bug
> 
> We just get new inode number from fs root or subvol/snap root,
> so we'd like to save fs/subvol/snap root's inode cache into disk.
> 
> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
> ---
>   fs/btrfs/inode-map.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index 0009705..8c0c25b 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -372,6 +372,12 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
>   	int prealloc;
>   	bool retry = false;
> 
> +	/* only fs tree and subvol/snap needs ino cache */
> +	if (root->root_key.objectid != BTRFS_FS_TREE_OBJECTID&&
> +	    (root->root_key.objectid<  BTRFS_FIRST_FREE_OBJECTID ||
> +	     root->root_key.objectid>  BTRFS_LAST_FREE_OBJECTID))
> +		return 0;
> +
>   	path = btrfs_alloc_path();
>   	if (!path)
>   		return -ENOMEM;

