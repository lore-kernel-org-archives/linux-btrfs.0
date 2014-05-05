Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-am1lp0016.outbound.protection.outlook.com ([213.199.154.16]:38344
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933028AbaEEPEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 11:04:10 -0400
From: George Pochiscan <george.pochiscan@sphs.ro>
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Unable to boot
Date: Mon, 5 May 2014 15:04:05 +0000
Message-ID: <1399302243852.20163@sphs.ro>
References: <1399024804436.53859@sphs.ro>,<B2BE5A00-6E38-4B2D-9A80-AB1F49F1830B@colorremedies.com>
In-Reply-To: <B2BE5A00-6E38-4B2D-9A80-AB1F49F1830B@colorremedies.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

Thanks for your response. I tried the steps you gave me, but still no luck.

Each time i try to mount ( normally, -o recovery, -o ro,recovery) i have the following error:

[root@localhost liveuser]# mount /dev/md127 /tmp/hdd
mount: wrong fs type, bad option, bad superblock on /dev/md127,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

For the simple  mount command the dmesg is : http://pastebin.com/TiPR7U2j
For mount -o recovery option, the dmesg is : http://pastebin.com/NURDTeYf
For mount -o ro,recovery options, the dmesg is : http://pastebin.com/UUmdWGgE


Thank you,
George Pochiscan
Support Engineer

Mobile: +40731831489
Phone: +40213225757
Fax: +40213222522
george.pochiscan@sphs.ro
www.spearheadsystems.ro
64 I.P. Pavlov Street, 1st District
Bucharest, Romania

IT innovation at its finest.

________________________________________
From: Chris Murphy <lists@colorremedies.com>
Sent: Friday, May 2, 2014 22:41
To: George Pochiscan
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unable to boot

On May 2, 2014, at 4:00 AM, George Pochiscan <george.pochiscan@sphs.ro> wrote:

> Hello,
>
> I have a problem with a server with Fedora 20 and BTRFS. This server had frequent hard restarts before the filesystem got corrupt and we are unable to boot it.
>
> We have a HP Proliant server with 4 disks @1TB each and Software RAID 5.
> It had Debian installed (i don't know the version) and right now i'm using fedora 20 live to try to rescue the  system.

Fedora 20 Live has kernel 3.11.10 and btrfs-progs 0.20.rc1.20131114git9f0c53f-1.fc20. So the general rule of thumb without knowing exactly what the problem and solution is, is to try a much newer kernel and btrfs-progs, like a Fedora Rawhide live media. These are built daily, but don't always succeed so you can go here to find the latest of everything:

https://apps.fedoraproject.org/releng-dash/

Find Fedora Live Desktop or Live KDE and click on details. Click the green link under descendants   livecd. And then under Output listing you'll see an ISO you can download, the one there right now is Fedora-Live-Desktop-x86_64-rawhide-20140502.iso - but of course this changes daily.

You might want to boot with kernel parameter slub_debug=- (that's a minus symbol) because all but Monday built Rawhide kernels have a bunch of kernel debug options enabled which makes it quite slow.


>
> When we try btrfsck /dev/md127 i have a lot of checksum errors, and the output is:
>
> Checking filesystem on /dev/md127
> UUID: e068faf0-2c16-4566-9093-e6d1e21a5e3c
> checking extents
> checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
> checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
> checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
> checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
> Csum didn't match
> checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
> checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
> checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
> checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
> Csum didn't match
> -----------------------------------------------------------------
>
> extent buffer leak: start 1006686208 len 4096
> found 32039247396 bytes used err is -22
> total csum bytes: 41608612
> total tree bytes: 388857856
> total fs tree bytes: 310124544
> total extent tree bytes: 22016000
> btree space waste bytes: 126431234
> file data blocks allocated: 47227326464
> referenced 42595635200
> Btrfs v3.12


I suggest a recent Rawhide build. And I suggest just trying to mount the file system normally first, and post anything that appears in dmesg. And if the mount fails, then try mount option -o recovery, and also post any dmesg messages from that too, and note whether or not it mounts. Finally if that doesn't work either then see if -o ro,recovery works and what kernel messages you get.


>
>
>
> When i attempt to repair i have the following error:
> -----------------------------------------
> Backref 1005817856 parent 5 root 5 not found in extent tree
> backpointer mismatch on [1005817856 4096]
> owner ref check failed [1006686208 4096]
> repaired damaged extent references
> Failed to find [1000525824, 168, 4096]
> btrfs unable to find ref byte nr 1000525824 parent 0 root 1  owner 1 offset 0
> btrfsck: extent-tree.c:1752: write_one_cache_group: Assertion `!(ret)' failed.
> Aborted
> ------------------------------------

You really shouldn't use --repair right off the bat, it's not a recommended early step, you should try normal mounting with newer kernels first, then recovery mount options first. Sometimes the repair option makes things worse. I'm not sure what its safety status is as of v3.14.

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ

Fedora includes btrfs-zero-log already so depending on the kernel messages you might try that before a btrfsck --repair.



Chris Murphy

