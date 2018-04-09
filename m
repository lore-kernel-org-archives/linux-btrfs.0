Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0139.outbound.protection.outlook.com ([104.47.34.139]:39793
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754792AbeDIDgp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Apr 2018 23:36:45 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Nikolay Borisov <nborisov@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix possible softlock on single core machines
Date: Mon, 9 Apr 2018 03:36:42 +0000
Message-ID: <DM5PR2101MB10321235FD09133CA3EAA688FBBF0@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <1522914015-32534-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1522914015-32534-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 6d74119f1a3e Btrfs: avoid taking the chunk_mutex in do_chunk_alloc.

The bot has also determined it's probably a bug fixing patch. (score: 55.2868)

The bot has tested the following trees: v4.16, v4.15.15, v4.14.32, v4.9.92, v4.4.126.

v4.16: Build OK!
v4.15.15: Build OK!
v4.14.32: Build OK!
v4.9.92: Build OK!
v4.4.126: Build OK!

--
Thanks,
Sasha