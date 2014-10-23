Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:36116 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbaJWW1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 18:27:08 -0400
Message-ID: <544980BA.8080007@pobox.com>
Date: Thu, 23 Oct 2014 15:27:06 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Mounting(multiply)? Options(stored)? Options(barriers)?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got several questions about mount features that I've been unable to 
find definitive answers for.

ITEM: So there are some mount options that I'd like to be able to pin 
onto a media like compress=lzo on a thumb drive I expect to get crowded. 
Is there a feature equivalent to the -o option to tune2fs either present 
or planned?

ITEM: Is there a means (or a plan for a means) to use a subvol as a 
means to prevent/change active features from propigating to a 
subdirectory? An example would be a means to turn off autodefrag or 
compression for a subvolume full of virtual machine images, whilest 
having it active for the bulk of the filesystem.

ITEM: If I make one file system and have subvols /__System /home and 
/VMs and mount those as / /home and /usr/local/VMs respectively, with 
differing feature options for each, will those options be separately 
honored or will the last-mounted or first-mounted subvolume's options 
take dominant effect? Compression, auto-defragment, and commit interval 
being of primary concern.

ITEM: Is there a no-compress attribute (or something similar) for 
negating compress= mount options on specific files or directories? How 
about a no-autodefrag?

(I'm about to set up a system and some standards that may last many 
years and I'm trying to find the reasonable bounds of where I need to do 
hard partitioning.)

--Rob.
