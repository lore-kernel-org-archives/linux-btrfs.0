Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab2FTQ1W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 12:27:22 -0400
Message-ID: <4FE1F9E4.5090301@zytor.com>
Date: Wed, 20 Jun 2012 09:27:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Feature request: true RAID-1 mode
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yet another boot loader support request.

Right now btrfs' definition of "RAID-1" with more than two devices is a
bit unorthodox: it stores on any two drives.  "True RAID-1" would
instead store N copies on each of N devices, the same way an actual
RAID-1 would operate with an arbitrary number of devices.

This means that a bootloader can consider a single device in isolation:
if the firmware gives access only to a single device, it can be booted.
 Since /boot is usually a very small amount of data, this is a very
reasonable tradeoff.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

