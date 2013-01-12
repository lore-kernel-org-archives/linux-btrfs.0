Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3996 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab3ALA37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 19:29:59 -0500
From: "Rick Liu" <rickliu@broadcom.com>
To: =?iso-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: how to resize (grow) device partition of a multi-device
 BTRFS filesystem?
Date: Sat, 12 Jan 2013 00:29:47 +0000
Message-ID: <7D0754FFADBD2D4785C1D233C497C47B1BCD8161@SJEXCHMB06.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> Hi Rick,
> 
> use
> btrfs fi resize <devid>:max
> to make btrfs use all space of disk <devid>
> 
[Rick Liu] 
Hi,

I tried, but it seems no effect.
(dev/sdc was 300GB and now is 500GB, )
After resize,
/dev/sdc1 is still 300GB.


# btrfs filesystem show
Label: 'local'  uuid: 828bee8c-a28c-443f-b19a-8e65e3f94963
        Total devices 3 FS bytes used 372.22GB
        devid    3 size 500.00GB used 259.06GB path /dev/sde1
        devid    4 size 500.00GB used 260.06GB path /dev/sdd
        devid    5 size 300.00GB used 0.00 path /dev/sdc1
Btrfs v0.19+

# btrfs fi resize 5:max /local
Resize '/local' of '5:max'

# btrfs filesystem show
Label: 'local'  uuid: 828bee8c-a28c-443f-b19a-8e65e3f94963
        Total devices 3 FS bytes used 372.22GB
        devid    3 size 500.00GB used 259.06GB path /dev/sde1
        devid    4 size 500.00GB used 260.06GB path /dev/sdd
        devid    5 size 300.00GB used 0.00 path /dev/sdc1
Btrfs v0.19+

