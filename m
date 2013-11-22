Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:36733 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3KVKeK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 05:34:10 -0500
Message-ID: <528F3320.8040800@giantdisaster.de>
Date: Fri, 22 Nov 2013 11:34:08 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Joshua Varghese <jvarghese@ocztechnology.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Receive fails (Could not find parent subvolume)
References: <528E467B.40002@ocztechnology.com> <528F283F.5060903@ocztechnology.com>
In-Reply-To: <528F283F.5060903@ocztechnology.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Nov 2013 01:47:43 -0800, Joshua Varghese wrote:
> Hi,
> 
> I'm trying to implement a mechanism for incremental backup using btrfs.
> I have two hardisks and each has a btrfs partition on it. I am able to
> take a snapshot of the source partition and send it to the backup disk
> using the send-recieve mechanism. When I try to send an incremental
> backup of a new snapshot with the previous snapshot as the parent btrfs
> command complains (ERROR: could not find parent subvolume). The kernel
> logs also record a error (kernel: could not find root 9). I've listed
> the actual commands and their outputs below. Please let me know if you
> need any more information.
> 
> # btrfs sub create check_backup
> /Create subvolume './check_backup/
> # touch check_backup/before_first_snap
> # btrfs sub snapshot -r check_backup/ first_snap
> /Create a readonly snapshot of 'check_backup/' in './first_snap'/
> # btrfs sub snapshot -r check_backup/ second_snap
> /Create a readonly snapshot of 'check_backup/' in './second_snap'/
> 
> <second volume mounted at /mnt/gentoo/>
> # btrfs send  first_snap | btrfs receive /mnt/gentoo/backup/test/
> /At subvol first_snap//
> //At subvol first_snap//
> /# btrfs send  -p first_snap second_snap/ | btrfs receive
> /mnt/gentoo/backup/test/
> /At subvol second_snap///
> //At snapshot second_snap//
> //ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 40e9283cdf98a796, UUID_KEY,
> 0fc9a258f8cd8da7) ret=-1, //error: No such file or directory//
> //ERROR: could not find parent subvolume//
> /
> /(kernel log): kernel: could not find root 9/

Works for me.

How old is your kernel (which version)? You need 3.12 or better if you
use the most recent btrfs-progs. New progs and old kernel doesn't work
in this case, new kernel and old progs would work.


> As I understand the send command would take a difference between the two
> snapshots and the send it to the receive. I used the file mechanism
> instead of the pipe and realized that the receive is the one that complains.
> I'd also read in the documentation
> (http://docs.oracle.com/cd/E37670_01/E37355/html/ol_sendrecv_btrfs.hml)
> about clone source. I don't understand its implication in incremental
> backup.
> 
> Regards,
> Josh

