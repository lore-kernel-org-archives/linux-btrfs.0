Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sn1nam01on0120.outbound.protection.outlook.com ([104.47.32.120]:62865
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751934AbeDFUGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 16:06:07 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 08/16] btrfs: add sanity check when resuming balance after
 mount
Date: Fri, 6 Apr 2018 20:06:05 +0000
Message-ID: <MW2PR2101MB1034A1F36200F757E05ED6BCFBBA0@MW2PR2101MB1034.namprd21.prod.outlook.com>
References: <a5729260c2f8b50912bf975b30081ab1dbd8c8fd.1522780026.git.dsterba@suse.com>
In-Reply-To: <a5729260c2f8b50912bf975b30081ab1dbd8c8fd.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed by the -stable helper bot and determined
to be a high probability candidate for -stable trees. (score: 16.7330)

The bot has tested the following trees: v4.16, v4.15.15, v4.14.32, v4.9.92, v4.4.126.

v4.16: Build OK!
v4.15.15: Build OK!
v4.14.32: Build OK!
v4.9.92: Failed to apply! Possible dependencies:
    509cdd5c938a ("btrfs: add sanity check when resuming balance after mount")

v4.4.126: Failed to apply! Possible dependencies:
    509cdd5c938a ("btrfs: add sanity check when resuming balance after mount")


Please let us know if you'd like to have this patch included in a stable tree.

--
Thanks,
Sasha