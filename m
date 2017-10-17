Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41396 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJQLMd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 07:12:33 -0400
Received: from mail-pg0-f70.google.com ([74.125.83.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1e4PnT-0005x3-VP
        for linux-btrfs@vger.kernel.org; Tue, 17 Oct 2017 11:12:32 +0000
Received: by mail-pg0-f70.google.com with SMTP id b192so1272711pga.14
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 04:12:31 -0700 (PDT)
Received: from localhost.localdomain ([175.41.48.77])
        by smtp.gmail.com with ESMTPSA id b1sm16895858pgn.94.2017.10.17.04.12.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Oct 2017 04:12:29 -0700 (PDT)
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: reproducable oops in btrfs/130 with latests mainline
Date: Tue, 17 Oct 2017 19:11:51 +0800
Message-Id: <20171017111151.4316-1-po-hsu.lin@canonical.com>
In-Reply-To: <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
References: <20161125080723.GA12776@infradead.org> <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

I can reproduce this on my side too, with Ubuntu 16.04 + 4.4.0-97 kernel.

PREEMPT config:
$ cat config-4.4.0-97-generic | grep PREEMPT
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set

Bug reports on launchpad:
https://bugs.launchpad.net/bugs/1718925
https://bugs.launchpad.net/bugs/1717443
