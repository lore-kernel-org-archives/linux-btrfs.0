Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40754 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754249Ab3LSWWA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 17:22:00 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52B2BBE1.8090306@gmail.com>
Date: Thu, 19 Dec 2013 15:21:56 -0700
Message-Id: <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com>
References: <52B2BBE1.8090306@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Kastorff <encryptio@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 19, 2013, at 2:26 AM, Chris Kastorff <encryptio@gmail.com> wrote:

> btrfs-progs v0.20-rc1-358-g194aa4a-dirty

Most of what you're using is in the kernel so this is not urgent but if it gets to needing btrfs check/repair, I'd upgrade to v3.12 progs:
https://www.archlinux.org/packages/testing/x86_64/btrfs-progs/


> sd 0:2:3:0: [sdd] Unhandled error code
> sd 0:2:3:0: [sdd]
> Result: hostbyte=0x04 driverbyte=0x00
> sd 0:2:3:0: [sdd] CDB:
> cdb[0]=0x2a: 2a 00 26 89 5b 00 00 00 80 00
> end_request: I/O error, dev sdd, sector 646535936
> btrfs_dev_stat_print_on_error: 7791 callbacks suppressed
> btrfs: bdev /dev/sdd errs: wr 315858, rd 230194, flush 0, corrupt 0, gen 0
> sd 0:2:3:0: [sdd] Unhandled error code
> sd 0:2:3:0: [sdd]
> Result: hostbyte=0x04 driverbyte=0x00
> sd 0:2:3:0: [sdd] CDB:
> cdb[0]=0x2a: 2a 00 26 89 5b 80 00 00 80 00
> end_request: I/O error, dev sdd, sector 646536064

These are hardware errors. And you have missing devices, or at least a message of missing devices. So if a device went bad, and a new one added without deleting the missing one, then the new device only has new data. Data hasn't been recovered and replicated to the replacement. So it's possible with a missing device that's not removed, and a 2nd device failure, to lose some data.

> btrfs read error corrected: ino 1 off 87601116364800 (dev /dev/sdf
> sector 62986400)
> 
> btrfs read error corrected: ino 1 off 87601116798976 (dev /dev/sdg
> sector 113318256)

I'm not sure what constitutes a btrfs read error, maybe the device it originally requested data from didn't have it where it was expected but was able to find it on these devices. If the drive itself has a problem reading a sector and ECC can't correct it, it reports the read error to libata. So kernel messages report this with a line that starts with the word "exception" and then a line with "cmd" that shows what command and LBAs where issued to the drive, and then a "res" line that should contain an error mask with the actual error - bus error, media error. Very often you don't see these and instead see link reset messages, which means the drive is hanging doing something (probably attempting ECC) but then the linux SCSI layer hits its 30 second time out on the (hanged) queued command and resets the drive instead of waiting any longer. And that's a problem also because it prevents bad sectors from being fixed by Btrfs. So they just get worse to the point where then it can't do anything about the situation.

So I think you need to post a full dmesg somewhere rather than snippets. And I'd also like to see the result from smartctl -x for the above three drives, sdd, sdf, and sdg. And we need to know what this missing drive message is about, if you've done a drive replacement and exactly what commands you used to do that and how long ago.


Chris Murphy