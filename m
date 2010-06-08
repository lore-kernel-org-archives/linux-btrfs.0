From: minskey guo <chaohong_guo@linux.intel.com>
Subject: Re: btrfs raid1 still recognized after being overwritten by md raid1
Date: Tue, 08 Jun 2010 09:29:00 +0800
Message-ID: <4C0D9CDC.5010307@linux.intel.com>
References: <4C0CB7FF.2080405@getsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "J. David Beutel" <list@getsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C0CB7FF.2080405@getsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2010 05:12 PM, J. David Beutel wrote:
> I created an md raid1 on partitions that had a btrfs raid1, but btrfs is
> still recognized on one of those partitions. (Is it finding some
> left-over, redundant metadata?) I'm concerned this will confuse me or
> btrfs in the future. How should I fix this?


Seem that btrfs-show checks the 1st superblock only, running the 
following can zap some part of that superblock,

   dd if=/dev/zero of=/dev/sda7 seek=128 bs=512 count=1

but probably, you need to zap the 2nd superblock as

  dd if=/dev/zero of=/dev/sda7 seek=128k bs=512 count=1


In case the block is being used, you can dump that block and
search "_BHRfS_M" in that block before clear it.

-minskey


> Details: after installing on btrfs for the first time, I created a btrfs
> raid1 in Fedora 13 on sda7 sdb7. Then, while reinstalling Fedora 13 from
> DVD, I created an md raid1 on those partitions, containing / type ext4.
> After booting onto that /, btrfs is still recognized on sda7, but sda7
> is also in md7, which is mounted on / as type ext4:
>
> [root@pikake jdb]# cat /proc/mdstat
> Personalities : [raid1]
> md127 : active (auto-read-only) raid1 sdb5[1] sda5[0]
> 204788 blocks super 1.0 [2/2] [UU]
>
> md8 : active raid1 sda8[0] sdb8[1]
> 218100 blocks super 1.0 [2/2] [UU]
>
> md7 : active raid1 sda7[0] sdb7[1]
> 48820156 blocks super 1.1 [2/2] [UU]
> bitmap: 1/1 pages [4KB], 65536KB chunk
>
> md3 : active raid1 sda3[0] sdb3[1]
> 12287936 blocks [2/2] [UU]
>
> unused devices: <none>
> [root@pikake jdb]# btrfs-show
> failed to read /dev/sdf
> failed to read /dev/sde
> failed to read /dev/sdd
> failed to read /dev/sdc
> failed to read /dev/sr0
> Label: none uuid: 3257ab1a-45de-43d3-bd84-a01ca93d0296
> Total devices 1 FS bytes used 7.71GB
> devid 1 size 48.83GB used 14.54GB path /dev/sda6
>
> Label: none uuid: c25ab51a-9fec-4e67-a5d8-4968e7d2e5e8
> Total devices 2 FS bytes used 7.69GB
> devid 1 size 46.56GB used 11.40GB path /dev/sda7
> *** Some devices missing
>
> Btrfs Btrfs v0.19
> [root@pikake jdb]# mount
> /dev/md7 on / type ext4 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> tmpfs on /dev/shm type tmpfs
> (rw,rootcontext="system_u:object_r:tmpfs_t:s0")
> /dev/md8 on /boot type ext4 (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> gvfs-fuse-daemon on /home/jdb/.gvfs type fuse.gvfs-fuse-daemon
> (rw,nosuid,nodev,user=jdb)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

