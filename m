Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0120.outbound.protection.outlook.com ([104.47.37.120]:5024
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751538AbeDFUFT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 16:05:19 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel-team@fb.com" <kernel-team@fb.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] bitmap: fix memset optimization on big-endian systems
Date: Fri, 6 Apr 2018 20:05:17 +0000
Message-ID: <MW2PR2101MB10348BF4123D24A55DD2817CFBBA0@MW2PR2101MB1034.namprd21.prod.outlook.com>
References: <817147544aa3ecc2b78d6cadeab713869d8805e6.1522709616.git.osandov@fb.com>
In-Reply-To: <817147544aa3ecc2b78d6cadeab713869d8805e6.1522709616.git.osandov@fb.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 2a98dc028f91 include/linux/bitmap.h: turn bitmap_set and bitmap_clear into memset when possible.

The bot has also determined it's probably a bug fixing patch. (score: 65.4067)

The bot has tested the following trees: v4.16, v4.15.15, v4.14.32.

v4.16: Build OK!
v4.15.15: Build OK!
v4.14.32: Build OK!

--
Thanks,
Sasha