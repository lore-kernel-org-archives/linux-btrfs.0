Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0111.outbound.protection.outlook.com ([104.47.37.111]:45123
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751363AbeDEQmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 12:42:36 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix NULL pointer dereference in log_dir_items
Date: Thu, 5 Apr 2018 16:42:34 +0000
Message-ID: <DM5PR2101MB1032B5A71C5024A50654000AFBBB0@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

[This is an automated email]

This commit has been processed by the -stable helper bot and determined
to be a high probability candidate for -stable trees. (score: 9.9156)

The bot has tested the following trees: v4.15.15, v4.14.32, v4.9.92, v4.4.126, 

v4.15.15: Build OK!
v4.14.32: Build OK!
v4.9.92: Build OK!
v4.4.126: Build OK!

Please let us know if you'd like to have this patch included in a stable tree.

--
Thanks.
Sasha