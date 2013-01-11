Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1660 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab3AKXjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 18:39:33 -0500
From: "Rick Liu" <rickliu@broadcom.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: how to resize (grow) device partition of a multi-device BTRFS
 filesystem?
Date: Fri, 11 Jan 2013 23:39:22 +0000
Message-ID: <7D0754FFADBD2D4785C1D233C497C47B1BCD8121@SJEXCHMB06.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm running OpenSUSE12.2 on VMware ESXi5.
I create /local using BTRFS file system with 3 devices (sdc, sdd, sde).
These 3 devices are VMware's virtual disk (vmdk files).

Instead of adding another new virtual disk,
ESXi allows to increase Virtual Disk size,
so I increase the size for 3 devices (sdc, sdd, sde) from 300GB to 500GB for each.

In EXT4 file system,
I can resize (grow) partition directly.
How to do this on BTRFS partition?



Thanks,

Rick

