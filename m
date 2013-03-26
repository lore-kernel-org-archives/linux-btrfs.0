Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [220.181.13.48] ([220.181.13.48]:56604 "EHLO m13-48.163.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab3CZED7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 00:03:59 -0400
Date: Tue, 26 Mar 2013 12:03:20 +0800 (CST)
From: lonat_front@163.com
To: linux-btrfs@vger.kernel.org
Subject: compression btrfs
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <15c1f0b7.19e37.13da4dd5320.Coremail.lonat_front@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

  I have used btrfs as a work partition with compression=zlib. The compression ratio is not satisfied to me. 

   I tracked my workloads in btrfs. The zlib module (zlib.c) seems work well: write size of each write operation in writepage function can be compressed into about 20%. 

  I suspent the workloads may impact the btrfs behavior. My workloads include really a large number of overwrite operations. 

   I briefly reviewed the code about the space reclaim in btrfs, and found the btrfs kicks the defrag off when the overwritten range is smaller than 16KB, And this is the only method of reclaiming freed extents with compression. Am I right?
   
   So my question is if btrfs can successfully reclaim the overwritten space when the cleaner thread can not be started, such as in the case that each overwrite operation is larger than 16KB? 
