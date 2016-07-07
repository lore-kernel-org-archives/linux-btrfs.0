Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.tech.triadic.us ([98.102.61.98]:52544 "EHLO
	SMTP.Tech.Triadic.US" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbcGGWZh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 18:25:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 07 Jul 2016 18:07:40 -0400
From: alexmcwhirter@triadic.us
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, sparclinux@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>,
        sparclinux-owner@vger.kernel.org
Subject: Re: btrfs module does not load on sparc64
In-Reply-To: <CADxRZqwhBoc9sNxxZ4a9ZJ0JiYWiL9xtG8T_ws4i61YrtNHtHg@mail.gmail.com>
References: <CADxRZqwhBoc9sNxxZ4a9ZJ0JiYWiL9xtG8T_ws4i61YrtNHtHg@mail.gmail.com>
Message-ID: <388170df4c75b613b1d8a7a29cc80cbb@triadic.us>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 10:29, Anatoly Pugachev wrote:
> Hi!
> 
> Compiled linux kernel (git version 4.7.0-rc6+) using my own kernel
> config file, enabling :
> 
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> CONFIG_BTRFS_DEBUG=y
> CONFIG_BTRFS_ASSERT=y
> 
> and now I can't load btrfs module:
> 
> # modprobe btrfs
> modprobe: ERROR: could not insert 'btrfs': Invalid argument
> 
> 
> and in logs (and on console):
> 
> [1897399.942697] Btrfs loaded, crc32c=crc32c-generic, debug=on, 
> assert=on
> [1897400.024645] BTRFS: selftest: sectorsize: 8192  nodesize: 8192
> [1897400.098089] BTRFS: selftest: Running btrfs free space cache tests
> [1897400.175863] BTRFS: selftest: Running extent only tests
> [1897400.241871] BTRFS: selftest: Running bitmap only tests
> [1897400.307877] BTRFS: selftest: Running bitmap and extent tests
> [1897400.380329] BTRFS: selftest: Running space stealing from bitmap to 
> extent
> [1897400.470517] BTRFS: selftest: Free space cache tests finished
> [1897400.542875] BTRFS: selftest: Running extent buffer operation tests
> [1897400.621710] BTRFS: selftest: Running btrfs_split_item tests
> [1897400.692929] BTRFS: selftest: Running extent I/O tests
> [1897400.757459] BTRFS: selftest: Running find delalloc tests
> [1897401.082670] BTRFS: selftest: Running extent buffer bitmap tests
> [1897401.161223] BTRFS: selftest: Setting straddling pages failed
> [1897401.233661] BTRFS: selftest: Extent I/O tests finished
> 
> 
> this is sparc64 sid/unstable debian:
> 
> # uname -a
> Linux nvg5120 4.7.0-rc6+ #38 SMP Thu Jul 7 14:51:23 MSK 2016 sparc64 
> GNU/Linux
> 
> # getconf PAGESIZE
> 8192
> 
> PS: using btrfs-progs from kdave repo,
> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git ,
> i'm able to create fs, but unable to mount:
> 
> root@nvg5120:/home/mator/btrfs-progs# ./mkfs.btrfs -f /dev/vg1/vol1
> btrfs-progs v4.6.1
> See http://btrfs.wiki.kernel.org for more information.
> 
> WARNING: failed to open /dev/btrfs-control, skipping device
> registration: No such device
> Label:              (null)
> UUID:               ddd8a268-62e5-444c-9baf-6ba1b2d4448b
> Node size:          16384
> Sector size:        8192
> Filesystem size:    15.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP               1.01GiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1    15.00GiB  /dev/vg1/vol1
> 
> 
> Can someone help please? Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

On kernel 4.6.2 i can load the module on quite a few machines (e6k, 
v210, v215, m4000, t5120). However, i can only create / mount raid 0,1, 
and 10 filesystems. raid 5 and 6 fails on both creation and mounting. 
Also, After creation / mounting of a raid 0/1/10 filesystem btrfs will 
eventually corrupt itself after a large amount of data has been written.

Not the same issue you are experiencing, but it's worthwhile to note.
