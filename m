Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail46.e.nsc.no ([193.213.115.46]:60740 "EHLO mail46.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2GAMK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jul 2012 08:10:27 -0400
Received: from [127.0.0.1] (ti0210a340-0278.bb.online.no [88.89.14.24])
	(authenticated bits=0)
	by mail46.nsc.no (8.14.4/8.14.4) with ESMTP id q61BodNp015013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 1 Jul 2012 13:50:48 +0200 (MEST)
Message-ID: <4FF0398F.3030802@online.no>
Date: Sun, 01 Jul 2012 13:50:39 +0200
From: Waxhead <waxhead@online.no>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfs RAID space utilization and bitrot reconstruction
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As far as I understand btrfs stores all data in huge chunks that are 
striped, mirrored or "raid5/6'ed" throughout all the disks added to the 
filesystem/volume.

How does btrfs deal with different sized disks? let's say that you for 
example have 10 different disks that are 100GB,200GB,300GB...1000GB and 
you create a btrfs filesystem with all the disks. How will the raid5 
implementation distribute chunks in such a setup. I assume the 
stripe+stripe+parity are separate chunks that are placed on separate 
disks but how does btrfs select the best disk to store a chunk on? In 
short will a slow disk slow down the entire "array", parts of it or will 
btrfs attempt to use the fastest disks first?

Also since btrfs checksums both data and metadata I am thinking that at 
least the raid6 implementation perhaps can (try to) reconstruct corrupt 
data (and try to rewrite it) before reading an alternate copy. Can 
someone please fill me in on the details here?

Finaly how does btrfs deals with advanced format (4k sectors) drives 
when the entire drive (and not a partition) is used to build a btrfs 
filesystem. Is proper alignment achieved?

