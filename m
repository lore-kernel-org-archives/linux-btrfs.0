Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51187 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3A2GZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:25:05 -0500
Message-ID: <51076B08.2040709@oracle.com>
Date: Tue, 29 Jan 2013 14:24:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 0/2] btrfs-progs: btrfslabel  source code consolidation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

As per David's suggestions, we should remove btrfslabel source code and move the
related functions to cmds-filesystems or utils.

I prefer to move them into utils since there already has a check_label() function
which can be used for the pre-checkup against the input label. 

This patch set is based on my previous v5 patches of "add get/set label support
against a mounted filesystem":
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21713


Thanks,
-Jeff
