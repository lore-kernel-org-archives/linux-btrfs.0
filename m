Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0119.outbound.protection.outlook.com ([104.47.38.119]:5646
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752607AbeGDRy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 13:54:59 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: A list of new findings when fuzzing Linux btrfs module
Date: Wed, 4 Jul 2018 17:54:56 +0000
Message-ID: <011B0D79-F8E6-46F1-9D82-8D60A4F3E925@gatech.edu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi BTRFS developers,

Here are a list of new issues I found:

200403	BUG() triggered in btrfs_free_dev_extent() when un-mounting a btrfs image
https://bugzilla.kernel.org/show_bug.cgi?id=200403

200405	Potential deadlock in btrfs_tree_lock() when perform writing to btrfs filesystem
https://bugzilla.kernel.org/show_bug.cgi?id=200405

200407	Potential deadlock when mount a btrfs image
https://bugzilla.kernel.org/show_bug.cgi?id=200407

200409	BUG() triggered in read_one_chunk() when mount a btrfs filesystem
https://bugzilla.kernel.org/show_bug.cgi?id=200409

200411	BUG() triggered in walk_up_proc() when mount a btrfs image
https://bugzilla.kernel.org/show_bug.cgi?id=200411

>From my testing, these issues cannot be corrected by latest introduced checks. Thanks!

-Wen