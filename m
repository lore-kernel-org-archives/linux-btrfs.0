Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:54137 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2HaTHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 15:07:55 -0400
Message-ID: <50410BBE.6030601@libero.it>
Date: Fri, 31 Aug 2012 21:08:46 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: M G Berberich <btrfs@oss.m-berberich.de>
CC: linux-btrfs@vger.kernel.org, Hubert Kario <kario@wit.edu.pl>
Subject: Re: =?UTF-8?B?4oCcQnVn4oCdLXJlcG9ydDogaW5jb25zaXN0ZW5jeSBrZXJuZWw=?=
 =?UTF-8?B?IDwtPiB0b29scw==?=
References: <20120828195244.GA15021@invalid> <503FAFF5.80204@libero.it>
In-Reply-To: <503FAFF5.80204@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/2012 08:24 PM, Goffredo Baroncelli wrote:
>
> And magically the filesystem is now composed by three disks. However 4
> physical devices are show. This because the disk /dev/vdi superblock
> says that the disk is still valid (after the "btrfs device del" the disk
> is not touched any more)

I have to correct myself. When a device is removed its superblock is 
zero-ed (from btrfs_rm_device():

[...]
         /*
          * at this point, the device is zero sized.  We want to
          * remove it from the devices list and zero out the old super
          */
         if (clear_super) {
                 /* make sure this device isn't detected as part of
                  * the FS anymore
                  */
                 memset(&disk_super->magic, 0, sizeof(disk_super->magic));
                 set_buffer_dirty(bh);
                 sync_dirty_buffer(bh);
         }
[...]


clear_super is set to true when the device is writeable.



However making a test I found both the behaviours: sometime the removed 
disk disappears from the output of "btrfs fi show" and sometime not...

May be that there is a bug somewhere...

