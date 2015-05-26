Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail.aei.mpg.de ([194.94.224.6]:36310 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbEZXNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 19:13:19 -0400
Received: from [192.168.1.106] (x55b3a8ff.dyn.telefonica.de [85.179.168.255])
	by umail.aei.mpg.de (Postfix) with ESMTPSA id 303A02001E3
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 01:04:37 +0200 (CEST)
From: Ian Hinder <ian.hinder@aei.mpg.de>
Content-Type: text/plain; charset=us-ascii
Subject: du vs qgroup
Message-Id: <FE5E411A-18A0-4D69-9997-050C05275019@aei.mpg.de>
Date: Wed, 27 May 2015 01:04:38 +0200
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a 350 GB btrfs filesystem in which I am storing backups of virtual machine disk images.  These are rsynced periodically from the VM host to a "current" subvolume, followed by a snapshot operation to a dated subvolume.  One disk image is about 50 GB in size, as reported by ls -l and du.  However, the qgroup assigned to the "current" subvolume reports a "refr" size of 75 GB.  I have performed a "btrfs quota rescan" to make sure the quota is up-to-date.  I have tried defragmenting the file, but this did not significantly help.

Is there an explanation for the discrepancy between the logical file size and the data used in btrfs to store it?

I have one theory, which is that when the updated VM image is synced into the current subvolume, the changes affect only a small part of each data storage node (I'm not sure if I'm using the terminology "node" correctly here), but each node needs to be duplicated due to the COW nature of the filesystem, and the fact that the nodes are shared with the existing snapshots, so they cannot be rewritten to be more efficient.  This means that most of the data in such a node is actually duplicated, even though it only counts once toward the logical size of the file.  I do not know how to determine the node size of my filesystem, but as far as I can tell from searching, the node size is never more than 65 K.  It seems to me unlikely that such a small node size could cause the problems I am seeing, but I suppose it's not impossible, especially because this virtual machine disk image hosts a number of git repositories, typically containing large numbers of small files, which have undergone significant churn in the past.  If this were the problem, would deduplication help, or does it operate only at the level of nodes?

I am using Linux version 3.16.0-38-generic, Ubuntu 14.04.2 LTS.  This is from August 2014.  I know that it is preferable to use the latest kernel for btrfs; Ubuntu provides up to 3.19.0-18, and I would consider upgrading if this is likely to help the problem.

What is the most up-to-date description of how btrfs stores data? I have found this, https://oss.oracle.com/~mason/btrfs/btrfs-design.html, for example.

-- 
Ian Hinder
http://members.aei.mpg.de/ianhin

