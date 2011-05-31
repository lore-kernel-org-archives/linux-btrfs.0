From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [3.0-rc1] kernel BUG at fs/btrfs/relocation.c:4285!
Date: Mon, 30 May 2011 21:13:53 -0400
Message-ID: <1306804322-sup-3529@shiny>
References: <4DE43607.2090105@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DE43607.2090105@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tsutomu Itoh's message of 2011-05-30 20:27:51 -0400:
> The panic occurred when 'btrfs fi bal /test5' was executed.
> 
> /test5 is as follows:
> # mount -o space_cache,compress=lzo /dev/sdc3 /test5
> #
> # btrfs fi sh /dev/sdc3
> Label: none  uuid: 38ec48b2-a64b-4225-8cc6-5eb08024dc64
>         Total devices 5 FS bytes used 7.87MB
>         devid    1 size 10.00GB used 2.02GB path /dev/sdc3
>         devid    2 size 15.01GB used 3.00GB path /dev/sdc5
>         devid    3 size 15.01GB used 3.00GB path /dev/sdc6
>         devid    4 size 20.01GB used 2.01GB path /dev/sdc7
>         devid    5 size 10.00GB used 2.01GB path /dev/sdc8
> 
> Btrfs v0.19-50-ge6bd18d
> # btrfs fi df /test5
> Data, RAID0: total=10.00GB, used=3.52MB
> Data: total=8.00MB, used=1.60MB
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=216.00KB
> Metadata: total=8.00MB, used=0.00

The oops is happening as we write inode cache during a commit during the
balance.  I did run a number of balances on the inode cache code, do you
have a test script that sets up the filesystem to recreate this?

-chris
