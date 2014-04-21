Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20883 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbaDUMm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 08:42:29 -0400
Message-ID: <535511FE.8070608@fb.com>
Date: Mon, 21 Apr 2014 08:41:34 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi df "unknown"
References: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
In-Reply-To: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/20/2014 04:18 PM, Chris Murphy wrote:
> kernel 3.15.0-0.rc1.git0.1.fc21.x86_64
> btrfs-progs v3.14
> 
> One 80GB virtual disk, formatted btrfs by installer and Fedora Rawhide installed to it. Post-install I see:
> 
> [root@localhost ~]# btrfs fi show
> Label: 'fedora'  uuid: d372e5d1-386f-460c-b036-611469e0155e
> 	Total devices 1 FS bytes used 4.00GiB
> 	devid    1 size 79.31GiB used 6.04GiB path /dev/sda3
> 
> Btrfs v3.14
> [root@localhost ~]# btrfs fi df /
> Data, single: total=4.01GiB, used=3.79GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=1.00GiB, used=215.69MiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=80.00MiB, used=0.00
> 
> 
> What is unknown?
> 


3.15 has this commit, it's the cause of the unknown.  We'll roll the progs patch 
into the next progs release, but it's nothing at all to worry about.

-chris

Author: David Sterba <dsterba@suse.cz>
Date:   Fri Feb 7 14:34:12 2014 +0100

    btrfs: export global block reserve size as space_info
    
    Introduce a block group type bit for a global reserve and fill the space
    info for SPACE_INFO ioctl. This should replace the newly added ioctl
    (01e219e8069516cdb98594d417b8bb8d906ed30d) to get just the 'size' part
    of the global reserve, while the actual usage can be now visible in the
    'btrfs fi df' output during ENOSPC stress.
    
    The unpatched userspace tools will show the blockgroup as 'unknown'.
    
    CC: Jeff Mahoney <jeffm@suse.com>
    CC: Josef Bacik <jbacik@fb.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <clm@fb.com>

