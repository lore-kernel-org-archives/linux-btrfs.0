Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:52175 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbaFFDh2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 23:37:28 -0400
Message-ID: <53913609.2010805@pobox.com>
Date: Thu, 05 Jun 2014 20:31:21 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Feature Question: stored mount options... is that in there?
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to store the default mount options in the file system a 
la ext4 and tune2fs?

In particular my initrd mounts the file system and then the system 
remounts it using fstab, but this tends to lead to rebuilds of the inode 
cache. The initrd doesn't have the inode_cache option but the fstab 
does. This creates lots "meh" on occasion.

It Would Be Better™ if there were a way to store that sort of thing on 
the file system itself. Said feature was very easy to use on ext4 for 
dealing with xattr and such.

-- Rob White.
