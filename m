From: Sander <sander@humilis.net>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 3 Apr 2009 09:32:28 +0200
Message-ID: <20090403073228.GA22406@cumulus>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Erwin van Londen <erwin.vanlonden@hds.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dear Erwin,

Erwin van Londen wrote (ao):
> Another thing is that some arrays have the capability to
> "thin-provision" volumes. In the back-end on the physical layer the
> array configures, let say, a 1 TB volume and virtually provisions 5TB
> to the host. On writes it dynamically allocates more pages in the pool
> up to the 5TB point. Now if for some reason large holes occur on the
> volume, maybe a couple of ISO images that have been deleted, what
> normally happens is just some pointers in the inodes get deleted so
> from an array perspective there is still data on those locations and
> will never release those allocated blocks. New firmware/microcode
> versions are able to reclaim that space if it sees a certain number of
> consecutive zero's and will reclaim that space to the volume pool. Are
> there any thoughts on writing a low-priority tread that zeros out
> those "non-used" blocks?

SSD would also benefit from such a feature as it doesn't need to copy
deleted data when erasing blocks.

The storage could use the ATA/SCSI commands TRIM, UNMAP and DISCARD for
that?

I have one question on thin provisioning: if Windows XP performs defrag
on a 20GB 'virtual' size LUN with 2GB in actuall use, whil the volume
grow to 20GB on the storage and never shrink afterwards anymore, while
the client still has only 2GB in use?

This would make thin provisioning on virtual desktops less useful.

Do you have any numbers on the performance impact of thin provisioning?
I can imagine that thin provisioning causes on-storage defragmentation
of disk images, which would kill any OS optimisations like grouping often
read files.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
