Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbbBKSxB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:53:01 -0500
Date: Wed, 11 Feb 2015 19:52:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs
 layout
Message-ID: <20150211185259.GM28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-24-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423439785-10260-24-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 07:56:24AM +0800, Anand Jain wrote:
> This adds an enhancement to show the seed fsid and devices.
> 
> The way sprouting handles fs_devices:
>       clone seed fs_devices and add to the fs_uuids
>       mem copy seed fs_devices and assign to fs_devices->seed (move dev_list)
>       evacuate seed fs_devices contents to hold sprout fs devices contents
> 
>   So to be inline with this fs_devices changes during seeding,
>   represent seed fsid under the sprout fsid, this is achieved
>   by using the kobject_move()
> 
> eg: showing two levels of seeding.

That's new to me, how does nested seeding work?

> find /sys/fs/btrfs/ -type d -name devices -exec ls {} \; -print
> 
> sde
> /sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/devices
> sdd
> /sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/53ac3265-0c34-4afd-9453-cc0d1a07be64/devices

The plain uuid is IMHO not the best naming convention, although it's
acceptable in the global list in /sys/fs/btrfs/* I'd rather avoid it if
it's mixed with other files.

Would it be enough to print all relevant seeding information into a
single file? If the "UUID" directoreis do not contain anything else,
that would be IMHO best.

Do the seeding fsids exist on their own in /sys/sf/btrfs? I haven't
tested the patchset so I'd probably find that out myself.
