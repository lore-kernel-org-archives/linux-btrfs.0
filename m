Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:17720 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752441Ab3JEUht convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 16:37:49 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53647 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VSYbj-003XXu-VB
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 14:37:48 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: snapshot vs subvolume confusion
Message-Id: <90FA70D3-F53C-4E00-8C78-799BC56DCE9C@colorremedies.com>
Date: Sat, 5 Oct 2013 14:37:45 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How to solve the problem of hundreds/thousands of snapshots of e.g. rootfs or home, appearing to applications (including an OS installer) as completely unrelated? Such a btrfs volume appears to have hundreds of OS installations, rather than one installation with hundreds of snapshots.

Lacking an agreed upon organizational hierarchy, no application can be relied upon to understand all of the different ways to do this outside of the file system through organization. So it seems like btrfs subvolumes need "subvolume type GUIDs" similar to GPT partition type GUIDs to indicate their function, and relationship to each other so this can be determined.

Does this functionality already exist?


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
