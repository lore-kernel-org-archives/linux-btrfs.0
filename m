Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64552 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaHSL6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 07:58:12 -0400
Date: Tue, 19 Aug 2014 19:58:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Chris Mason <clm@fb.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Abhay Sachan <lkp.abhay@gmail.com>
Subject: [btrfs] 8d875f95: xfstests.generic.226.fail
Message-ID: <20140819115820.GA21418@localhost>
References: <20140816075233.GA26842@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140816075233.GA26842@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

We noticed an xfstests failure on commit

8d875f95da43c6a8f18f77869f2ef26e9594fecc ("btrfs: disable strict file flushes for renames and truncates")

It's 100% reproducible in the 5 test runs.

test case: snb-drag/xfstests/4HDD-btrfs-generic-mid

27b9a8122ff71a8  8d875f95da43c6a8f18f77869
---------------  -------------------------
                    %change               %stddev
                       |                 /
         0           +Inf%          1 ± 0%  TOTAL xfstests.generic.226.fail

Thanks,
Fengguang
