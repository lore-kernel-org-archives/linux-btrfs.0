Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail.aei.mpg.de ([194.94.224.6]:45224 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaARAcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:32:36 -0500
Received: from [192.168.1.3] (g226058105.adsl.alicedsl.de [92.226.58.105])
	by umail.aei.mpg.de (Postfix) with ESMTPSA id BCDAD201292
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 01:23:41 +0100 (CET)
From: Ian Hinder <ian.hinder@aei.mpg.de>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs and ECC RAM
Message-Id: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
Date: Sat, 18 Jan 2014 01:23:41 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been reading a lot of articles online about the dangers of using ZFS with non-ECC RAM.  Specifically, the fact that when good data is read from disk and compared with its checksum, a RAM error can cause the read data to be incorrect, causing a checksum failure, and the bad data might now be written back to the disk in an attempt to correct it, corrupting it in the process.  This would be exacerbated by a scrub, which could run through all your data and potentially corrupt it.  There is a strong current of opinion that using ZFS without ECC RAM is "suicide for your data".

I have been unable to find any discussion of the extent to which this is true for btrfs.  Does btrfs handle checksum errors in the same way as ZFS, or does it perform additional checks before writing "corrected" data back to disk?  For example, if it detects a checksum error, it could read the data again to a different memory location to determine if the error existed in the disk copy or the memory.

>From what I've been reading, it sounds like ZFS should not be used with non-ECC RAM.  This is reasonable, as ZFS' resource requirements mean that you probably only want to run it on server-grade hardware anyway.  But with btrfs eventually being the default filesystem for Linux, that would mean that all linux machines, even cheap consumer-grade hardware, would need ECC RAM, or forego many of the advantages of btrfs.

What is the situation?

-- 
Ian Hinder
http://numrel.aei.mpg.de/people/hinder

