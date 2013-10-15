Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53366 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759439Ab3JOUGf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 16:06:35 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:62529 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VWAsw-000LXk-SY
	for linux-btrfs@vger.kernel.org; Tue, 15 Oct 2013 14:06:31 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't mount subvol if default subvol is changed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
Date: Tue, 15 Oct 2013 14:06:26 -0600
Message-Id: <1E6FA7FF-35F1-4284-945F-D912865E3688@colorremedies.com>
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 15, 2013, at 1:23 PM, Chris Murphy <lists@colorremedies.com> wrote:

> After changing the default subvolume, I can't mount a nested subvolume with a correct relative pathname to the default subvolume; it can only be mounted by absolute path or subvolid.
> 
> Setup: 
> 3.11.4-302.fc20.x86_64
> btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64
> dir = a directory, sub=a subvolume, nested=a subvolume; set-default is top level 5
> 
> 
> # mount -o subvol=dir/sub /dev/vda1 /mnt
> # btrfs subvol list /mnt
> ID 263 gen 140 top level 5 path dir/sub
> ID 264 gen 140 top level 263 path nested
> 
> # btrfs subvol set-default 263 /mnt
> # umount /mnt
> # mount -o subvol=nested /dev/vda1 /mnt
> mount: mount(2) failed: No such file or directory
> # mount -o subvol=/nested /dev/vda1 /mnt
> mount: mount(2) failed: No such file or directory
> 
> # mount -o subvol=/dir/sub/nested /dev/vda1 /mnt
> [works]
> # umount  /mnt
> # mount -o subvolid=264 /dev/vda1 /mnt
> [works]
> 
Further both of these work and produce the same results

# mount -o subvol=/dir/sub/nested /dev/vda1 /mnt
# mount -o subvol=dir/sub/nested /dev/vda1 /mnt

I think that's wrong, unless set-default is effectively deprecated. Is it? /dir/ and dir/ are not the same thing, but even with set-default 263 both of those work as if they were the same thing.


Chris Murphy