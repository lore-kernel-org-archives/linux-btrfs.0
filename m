Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:34761 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2E2WkF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 18:40:05 -0400
Received: by qabj40 with SMTP id j40so2628529qab.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 15:40:05 -0700 (PDT)
Message-ID: <4FC55043.4050004@gmail.com>
Date: Tue, 29 May 2012 18:40:03 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FC54A5D.8000600@gmail.com>
In-Reply-To: <4FC54A5D.8000600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After command:
  sudo /usr/local/bin/btrfs device scan

i got new lines in dmesg:


11329.598535] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 2 
transid 9096 /dev/sdb
[11329.599885] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 3 
transid 9095 /dev/sdd
[11329.600840] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 1 
transid 9096 /dev/sda
[11329.602083] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 4 
transid 9096 /dev/sde
[11329.603036] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 5 
transid 9096 /dev/sdf

looks like /dev/sdd lost one transid.
Is it possible to roll back on transid 9095?

Thanks

On 05/29/2012 06:14 PM, Maxim Mikheev wrote:
> Hi Everyone,
>
> I recently decided to use btrfs. It works perfectly for a week even 
> under heavy load. Yesterday I destroyed backups as cannot afford to 
> have ~10TB in backups. I decided to switch on Btrfs because it was 
> announced that it stable already
> I need to recover ~5TB data, this data is important and I do not have 
> backups....
>
>
>  uname -a
> Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02 
> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> sudo mount -o recovery /dev/sdb /tank
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> dmesg:
> [ 9612.971149] device fsid c9776e19-37eb-4f9c-bd6b-04e8dde97682 devid 
> 2 transid 9096 /dev/sdb
> [ 9613.048476] btrfs: enabling auto recovery
> [ 9613.048482] btrfs: disk space caching is enabled
> [ 9621.172540] parent transid verify failed on 5468060241920 wanted 
> 9096 found 7621
> [ 9621.181369] parent transid verify failed on 5468060241920 wanted 
> 9096 found 7621
> [ 9621.182167] btrfs read error corrected: ino 1 off 5468060241920 
> (dev /dev/sdd sector 2143292648)
> [ 9621.182181] Failed to read block groups: -5
> [ 9621.193680] btrfs: open_ctree failed
>
> sudo /usr/local/bin/btrfs-find-root /dev/sdb
> ...................................
> Well block 4455562448896 seems great, but generation doesn't match, 
> have=9092, want=9096
> Well block 4455568302080 seems great, but generation doesn't match, 
> have=9091, want=9096
> Well block 4848395739136 seems great, but generation doesn't match, 
> have=9093, want=9096
> Well block 4923796594688 seems great, but generation doesn't match, 
> have=9094, want=9096
> Well block 4923798065152 seems great, but generation doesn't match, 
> have=9095, want=9096
> Found tree root at 5532762525696
>
>
> $ sudo btrfs-restore -v -t 4923798065152 /dev/sdb ./
> parent transid verify failed on 4923798065152 wanted 9096 found 9095
> parent transid verify failed on 4923798065152 wanted 9096 found 9095
> parent transid verify failed on 4923798065152 wanted 9096 found 9095
> parent transid verify failed on 4923798065152 wanted 9096 found 9095
> Ignoring transid failure
> Root objectid is 5
> Restoring ./Irina
> Restoring ./Irina/.idmapdir2
> Skipping existing file ./Irina/.idmapdir2/4.bucket.lock
> If you wish to overwrite use the -o option to overwrite
> Skipping existing file ./Irina/.idmapdir2/7.bucket
> Skipping existing file ./Irina/.idmapdir2/15.bucket
> Skipping existing file ./Irina/.idmapdir2/12.bucket.lock
> Skipping existing file ./Irina/.idmapdir2/cap.txt
> Skipping existing file ./Irina/.idmapdir2/5.bucket
> Restoring ./Irina/.idmapdir2/10.bucket.lock
> Restoring ./Irina/.idmapdir2/6.bucket.lock
> Restoring ./Irina/.idmapdir2/8.bucket
> ret is -3
>
>
>  sudo btrfs-zero-log /dev/sdb
> ...........................
> parent transid verify failed on 5468231311360 wanted 9096 found 7621
> parent transid verify failed on 5468231311360 wanted 9096 found 7621
> parent transid verify failed on 5468060102656 wanted 9096 found 7621
> Ignoring transid failure
> leaf parent key incorrect 59310080
> btrfs-zero-log: extent-tree.c:2578: alloc_reserved_tree_block: 
> Assertion `!(ret)' failed.
>
> Help me please.....
>
> Max
