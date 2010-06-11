From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: btrfs: hanging processes - race condition?
Date: Fri, 11 Jun 2010 09:12:42 +0800
Message-ID: <20100611011242.GA22585@sli10-desk.sh.intel.com>
References: <Pine.LNX.4.64.1006101022570.12518@lyn-del-uti-015>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	yanmin.zhang@intel.com, tim.c.chen@intel.com
To: Jerome Ibanes <Jerome@ops.zillow.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1006101022570.12518@lyn-del-uti-015>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 11, 2010 at 01:41:41AM +0800, Jerome Ibanes wrote:
> List,
> 
> I ran into a hang issue (race condition: cpu is high when the server is
> idle, meaning that btrfs is hanging, and IOwait is high as well) running
> 2.6.34 on debian/lenny on a x86_64 server (dual Opteron 275 w/ 16GB ram).
> The btrfs filesystem live on 18x300GB scsi spindles, configured as Raid-0,
> as shown below:
> 
> Label: none  uuid: bc6442c6-2fe2-4236-a5aa-6b7841234c52
>          Total devices 18 FS bytes used 2.94TB
>          devid    5 size 279.39GB used 208.33GB path /dev/cciss/c1d0
>          devid   17 size 279.39GB used 208.34GB path /dev/cciss/c1d8
>          devid   16 size 279.39GB used 209.33GB path /dev/cciss/c1d7
>          devid    4 size 279.39GB used 208.33GB path /dev/cciss/c0d4
>          devid    1 size 279.39GB used 233.72GB path /dev/cciss/c0d1
>          devid   13 size 279.39GB used 208.33GB path /dev/cciss/c1d4
>          devid    8 size 279.39GB used 208.33GB path /dev/cciss/c1d11
>          devid   12 size 279.39GB used 208.33GB path /dev/cciss/c1d3
>          devid    3 size 279.39GB used 208.33GB path /dev/cciss/c0d3
>          devid    9 size 279.39GB used 208.33GB path /dev/cciss/c1d12
>          devid    6 size 279.39GB used 208.33GB path /dev/cciss/c1d1
>          devid   11 size 279.39GB used 208.33GB path /dev/cciss/c1d2
>          devid   14 size 279.39GB used 208.33GB path /dev/cciss/c1d5
>          devid    2 size 279.39GB used 233.70GB path /dev/cciss/c0d2
>          devid   15 size 279.39GB used 209.33GB path /dev/cciss/c1d6
>          devid   10 size 279.39GB used 208.33GB path /dev/cciss/c1d13
>          devid    7 size 279.39GB used 208.33GB path /dev/cciss/c1d10
>          devid   18 size 279.39GB used 208.34GB path /dev/cciss/c1d9
> Btrfs v0.19-16-g075587c-dirty
> 
> The filesystem, mounted in /mnt/btrfs is hanging, no existing or new
> process can access it, however 'df' still displays the disk usage (3TB out
> of 5). The disks appear to be physically healthy. Please note that a
> significant number of files were placed on this filesystem, between 20 and
> 30 million files.
> 
> The relevant kernel messages are displayed below:
> 
> INFO: task btrfs-submit-0:4220 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> btrfs-submit- D 000000010042e12f     0  4220      2 0x00000000
>   ffff8803e584ac70 0000000000000046 0000000000004000 0000000000011680
>   ffff8803f7349fd8 ffff8803f7349fd8 ffff8803e584ac70 0000000000011680
>   0000000000000001 ffff8803ff99d250 ffffffff8149f020 0000000081150ab0
> Call Trace:
>   [<ffffffff813089f3>] ? io_schedule+0x71/0xb1
>   [<ffffffff811470be>] ? get_request_wait+0xab/0x140
>   [<ffffffff810406f4>] ? autoremove_wake_function+0x0/0x2e
>   [<ffffffff81143a4d>] ? elv_rq_merge_ok+0x89/0x97
>   [<ffffffff8114a245>] ? blk_recount_segments+0x17/0x27
>   [<ffffffff81147429>] ? __make_request+0x2d6/0x3fc
>   [<ffffffff81145b16>] ? generic_make_request+0x207/0x268
>   [<ffffffff81145c12>] ? submit_bio+0x9b/0xa2
>   [<ffffffffa01aa081>] ? btrfs_requeue_work+0xd7/0xe1 [btrfs]
>   [<ffffffffa01a5365>] ? run_scheduled_bios+0x297/0x48f [btrfs]
>   [<ffffffffa01aa687>] ? worker_loop+0x17c/0x452 [btrfs]
>   [<ffffffffa01aa50b>] ? worker_loop+0x0/0x452 [btrfs]
>   [<ffffffff81040331>] ? kthread+0x79/0x81
>   [<ffffffff81003674>] ? kernel_thread_helper+0x4/0x10
>   [<ffffffff810402b8>] ? kthread+0x0/0x81
>   [<ffffffff81003670>] ? kernel_thread_helper+0x0/0x10
This looks like the issue we saw too, http://lkml.org/lkml/2010/6/8/375.
This is reproduceable in our setup.

Thanks,
Shaohua
