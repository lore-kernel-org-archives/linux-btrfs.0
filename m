Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33127 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932457AbcLPXsH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 18:48:07 -0500
Received: by mail-qt0-f194.google.com with SMTP id n6so12643161qtd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 15:48:07 -0800 (PST)
Received: from [192.168.0.2] (c-76-124-64-166.hsd1.pa.comcast.net. [76.124.64.166])
        by smtp.gmail.com with ESMTPSA id n188sm4866569qkc.30.2016.12.16.15.48.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Dec 2016 15:48:06 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: "John L. Center" <jlcenter15@gmail.com>
Subject: uncorrectable error, but no file there
Message-ID: <26f42ead-53d3-a7d3-d7bf-597ed7ad5342@gmail.com>
Date: Fri, 16 Dec 2016 18:48:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I ran a btrfs scrub & found 3 uncorrectable errors:

[ 5461.412007] BTRFS warning (device md126p2): checksum error at logical
193296359424 on dev /dev/md126p2, sector 379645488, root 257, inode
1795724, offset 217088, length 4096, links 1 (path:
usr/lib/x86_64-linux-gnu/tracker-1.0/libtracker-data.so.0.0.0)
[ 5461.412010] BTRFS error (device md126p2): bdev /dev/md126p2 errs: wr
0, rd 0, flush 0, corrupt 1, gen 0


[11697.574762] BTRFS warning (device md126p2): checksum error at logical
1093372104704 on dev /dev/md126p2, sector 2140817192, root 257, inode
2428736, offset 20480, length 4096, links 1 (path:
opt/WS/build/media_build/v4l/tm6000-stds.o)
[11697.574766] BTRFS error (device md126p2): bdev /dev/md126p2 errs: wr
0, rd 0, flush 0, corrupt 2, gen 0


[12411.525644] BTRFS warning (device md126p2): checksum error at logical
1198857195520 on dev /dev/md126p2, sector 2328296072, root 257, inode
2689483, offset 28672, length 782, links 1 (path:
usr/share/texlive/texmf-dist/fonts/type1/public/pxfonts/pxbexa.pfb)
[12411.525646] BTRFS error (device md126p2): bdev /dev/md126p2 errs: wr
0, rd 0, flush 0, corrupt 3, gen 0


Two of the errors were at files that were installed as part of packages
& one was created when I compiled some drivers.  I deleted the driver
file & reinstalled the 2 packages.  When I ran scrub again, I still had
1 uncorrectable error, but noticed that btrfs wrote to dmesg that 4 were
found:

[61530.256323] BTRFS warning (device md126p2): checksum error at logical
193296359424 on dev /dev/md126p2, sector 379645488, root 257, inode
1795724, offset 217088: path resolving failed with ret=-2
[61530.256325] BTRFS error (device md126p2): bdev /dev/md126p2 errs: wr
0, rd 0, flush 0, corrupt 4, gen 0

Btrfs scrub only reported that 1 was found:

john@mariposa:~$ sudo btrfs scrub status -d /
scrub status for ac8fcd40-8879-4416-8259-c30980e526d2
scrub device /dev/md126p2 (id 1) history
	scrub started at Fri Dec 16 15:19:03 2016 and finished after 02:25:27
	total bytes scrubbed: 1.14TiB with 1 errors
	error details: csum=1
	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

Does btrfs keep a running tally of the errors found between runs?  I
never noticed this before, but this is also the first uncorrectable
errors I've had since rebuilding by system.  Also, notice that the one
error it found represented the space that was occupied by the first
file, libtracker-data.so.0.0.0.  When I reinstalled the package, it
didn't overwrite the inode that the file was originally at.  How do I
clean up this inode so that my btrfs partition is error free again?  :-)

Also, what would have caused this kind of error?  It's been running well
since I rebuilt it.  SMART has found no problem with the drives.  I'm
running Ubuntu 16.04 w/ kernel 4.8.15 & btrfs-progs v4.8.5-dirty.

Thanks.

	-John

