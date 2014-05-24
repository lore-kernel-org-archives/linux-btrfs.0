Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:60864
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbaEXCYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 22:24:11 -0400
Message-ID: <538002C9.8080503@pobox.com>
Date: Fri, 23 May 2014 19:24:09 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BUG: Replacing a directory with a subvolume breaks incremental snapshots
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

If you remove an existing directory and then create a subvolume with the 
same name the incremental send (btrfs send -p) will die with errno==2 
(file not found).

Steps to Reproduce:

btrfs subvol create scratch # make a playground
mkdir scratch/example
btrfs subvol snap -r scratch scratch_BEFORE
rmdir scratch/example
btrfs subvol create scratch/example
btrfs subvol snap -r scratch scratch_AFTER
btrfs send -p scratch_BEFORE scratch_AFTER >/dev/null

The output produced:
At subvol scratch_AFTER
ERROR: send ioctl failed with -2: No such file or directory

