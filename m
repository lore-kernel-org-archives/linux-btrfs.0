Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54618 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbDNHhW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 03:37:22 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 82ADAEC22
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 17:37:18 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: directory defrag
Date: Tue, 14 Apr 2015 07:37:17 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201504140737.17826.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current defragmentation options seem to only support defragmenting named 
files/directories or a recursive defragmentation of files and directories.

I'd like to recursively defragment directories.  One of my systems has a large 
number of large files, the files are write-once and read performance is good 
enough.  However performance of "ls -al" is often very poor, presumably due to 
metadata fragmentation.

The other thing I'd still like is the ability to force all metadata allocation 
to be from specified disks.  I'd like to have a pair of SSDs for RAID-1 storage 
of metadata and a set of hard drives for RAID-1 storage of data.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
