Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:39940 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABI47 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2014 03:56:59 -0500
Message-ID: <52C5280F.8090208@automatix.de>
Date: Thu, 02 Jan 2014 09:49:19 +0100
From: Jojo <jojo@automatix.de>
MIME-Version: 1.0
To: Sulla <Sulla@gmx.at>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at>
In-Reply-To: <52C2AE7C.5020601@gmx.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 31.12.2013 12:46, schrieb Sulla:
> Dear all!
>
> On my Ubuntu Server 13.10 I use a RAID5 blockdevice consisting of 3 WD20EARS
> drives. On this I built a LVM and in this LVM I use quite normal partitions
> /, /home, SWAP (/boot resides on a RAID1.) and also a custom /data
> partition. Everything (except boot and swap) is on btrfs.
>
> sometimes my system hangs for quite some time (top is showing a high wait
> percentage), then runs on normally. I get kernel messages into
> /var/log/sylsog, see below. I am unable to make any sense of the kernel
> messages, there is no reference to the filesystem or drive affected (at
> least I can not find one).
>
> Question: What is happening here?
> * Is a HDD failing (smart looks good, however)
> * Is something wrong with my btrfs-filesystem? with which one?
> * How can I find the cause?
>
Moin Wolfgang,
first ot: Happy new Year,

over the last celebration days one of our servers (ubuntu 13.04) with 
custom kernel 3.11.04 did quite simular things, also rais5/raid6.
Our Problem was writing to backup showed quit the same kernelog.
Also btrfs-transaction was hanging.
Also Filesystem usage with 83% looked fine. But that was not true.

After some time eating investigation I found, that BTRFS may have in 
3.11.x and other kernels(?) a problem with free block lists and 
fragmentation.

Our Server was able to self recover after defragmentation and 
compressing run.

We had problems with end-of-free blocks.
After rebuilding the free block list and running defrag the server got 
enough free blocks to operate well.

To be able to do that, we were forced to use the btrfs-git kernel and 
also the btrfs-progs from git. (3.13-rcX)

I did on 26.12.13:
# umount /ar
# btrfsck --repair --init-extent-tree /dev/sda1
# mount -o clear_cache,skip_balance,autodefrag /dev/sda1 /ar
# btrfs fi defragment -rc /ar/backup

But attention, I thougt 83% used space shoud be enough "free blocks", 
but this was wrong. It seems that BTRFS free Block lists are somewhat 
errous.
Especially "balance" may crash if an file has got too many 
extents/fragments, and allocating space may also hang if
free blocks are running low.

During the defragmentation run the response of the Server was getting 
slow, but did not stop in Read Access.

Our state today:
root@bk:~# df -m /ar
Dateisystem    1M-Blöcke Benutzt Verfügbar Verw% Eingehängt auf
/dev/sda1       13232966 7213717   3181874   70% /ar

root@bk:~# btrfs fi show /ar
Label: Archiv+Backup  uuid: 72b710aa-49a0-4ff5-a470-231560bfee81
         Total devices 5 FS bytes used 6.88TiB
         devid    1 size 2.73TiB used 2.70TiB path /dev/sda1
         devid    2 size 2.73TiB used 2.70TiB path /dev/sdb1
         devid    3 size 2.73TiB used 2.70TiB path /dev/sdc1
         devid    4 size 2.73TiB used 2.70TiB path /dev/sdd1
         devid    5 size 1.70TiB used 4.25GiB path /dev/sde4

Btrfs v3.12
root@bk:~# btrfs fi df /ar
Data, single: total=8.00MiB, used=0.00
Data, RAID5: total=8.10TiB, used=6.87TiB
System, single: total=4.00MiB, used=0.00
System, RAID5: total=12.00MiB, used=600.00KiB
Metadata, single: total=8.00MiB, used=0.00
Metadata, RAID5: total=12.25GiB, used=10.41GiB

Today the server completely recovered to full operation.

Is there a plan ongoing to hangle such out of free blocks/space 
situations more comfortable?

TIA
J. Sauer

-- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg
