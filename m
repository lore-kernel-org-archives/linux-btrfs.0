Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34841 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbcAENi5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 08:38:57 -0500
Received: by mail-io0-f171.google.com with SMTP id 77so155776081ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 05:38:57 -0800 (PST)
Subject: Re: device removal seems to be very slow (kernel 4.1.15)
To: David Goodwin <david@codepoets.co.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <568BBF5D.40304@codepoets.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <568BC71D.5050500@gmail.com>
Date: Tue, 5 Jan 2016 08:37:33 -0500
MIME-Version: 1.0
In-Reply-To: <568BBF5D.40304@codepoets.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-05 08:04, David Goodwin wrote:
> Using btrfs progs 4.3.1 on a Vanilla kernel.org 4.1.15 kernel.
>
> time btrfs device delete /dev/xvdh /backups
>
> real    13936m56.796s
> user    0m0.000s
> sys     1351m48.280s
>
>
> (which is about 9 days).
>
>
> Where :
>
> /dev/xvdh was 120gb in size.
OK, based on the device names, you're running this inside a Xen instance 
with para-virtualized storage drivers (or Amazon EC2, which is the same 
thing at it's core), and that will have at least some impact on 
performance (although it will be less impact than if you were using full 
virtualization). If you have administrative access to Domain 0, and can 
afford to have the VM down, I would suggest checking how long the 
equivalent operation takes from Domain 0 (note that to properly check 
this, you would need to re-add the device to the FS, re-balance the FS, 
and then delete the device).  If you get similar results in Domain 0 and 
in the VM, then that rules out virtualization as the bottleneck (for 
para-virtualized storage backed by physical block devices on the local 
system (as opposed to files, or networked block devices), you should see 
at most a 10% performance gain running it in Domain 0 assuming both the 
VM and Domain 0 have the same number of VCPU's and same amount of RAM).
>
>
> /backups is a single / "raid 0" volume that now looks like :
>
> Label: 'BACKUP_BTRFS_SNAPS'  uuid: 6ee08c31-f310-4890-8424-b88bb77186ed
>      Total devices 3 FS bytes used 301.09GiB
>      devid    1 size 100.00GiB used 90.00GiB path /dev/xvdg
>      devid    3 size 220.00GiB used 196.06GiB path /dev/xvdi
>      devid    4 size 221.00GiB used 59.06GiB path /dev/xvdj
>
>
> There are about 400 snapshots on it.
This may be part of the issue.  Assuming that /dev/xvdh was mostly full 
like /dev/xvdg and /dev/xvdi are now, then that would mean it would take 
longer to remove from the filesystem, because all the chunks that are 
partially on the device being removed need to be moved to another 
device. On top of that, whenever a chunk moves, metadata needs to be 
updated, which means a lot of updates if you have a lot of shared 
extents, which I'm assuming is the case based on the number of snapshots.
