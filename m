Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51336C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 15:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119B620652
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 15:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 119B620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nevion.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbeJDWuU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 18:50:20 -0400
Received: from mta04.intility.com ([137.221.30.8]:52633 "EHLO
        mta04.intility.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeJDWuU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 18:50:20 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2018 18:50:18 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FGGQAyNbZb/3MNAwpbHgEGBwaBZQKCa?=
 =?us-ascii?q?oEnCowBpQmBeQwBGAsLiQc/AwwBAwEBAgEBAgEBAoEFAQuCNiIRPA8+AQEBAQE?=
 =?us-ascii?q?BAQEBTQINazk0HQE+OAomAQQbgxqCEKVGhHeFGAWNBD+DAnUBg0cDARiHHwKdV?=
 =?us-ascii?q?wmBVYR1hW+DfwgXgUyOH4kEgxiGY4I5AgQCBAUCFIFwMoEuMxojUIJsils7hT5?=
 =?us-ascii?q?vAYxEgR8BAQ?=
X-IronPort-AV: E=Sophos;i="5.54,340,1534802400"; 
   d="scan'208";a="6389445"
Received: from i2v-ex16-015.i04.local ([10.3.13.115])
  by mta04.intility.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Oct 2018 17:46:27 +0200
Received: from I2V-EX16-015.i04.local (10.3.13.248) by I2V-EX16-015.i04.local
 (10.3.13.248) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1415.2; Thu, 4 Oct 2018
 17:46:27 +0200
Received: from I2V-EX16-015.i04.local ([fe80::fd58:203f:928c:b7b6]) by
 I2V-EX16-015.i04.local ([fe80::fd58:203f:928c:b7b6%6]) with mapi id
 15.01.1415.007; Thu, 4 Oct 2018 17:46:27 +0200
From:   Michael Firth <MFirth@nevion.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Update on btrfs patch status
Thread-Topic: Update on btrfs patch status
Thread-Index: AdRb+I0U+t3zSYjOTHOso4TxR2OwjA==
Date:   Thu, 4 Oct 2018 15:46:27 +0000
Message-ID: <8821a1f88e014f87b707bd7427c125e0@nevion.com>
Accept-Language: en-GB, nb-NO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.73.12.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Earlier this week I suffered some (minor) data loss after a kernel oops from BTRFS.

It looked very like the issue described in this mailing list post from 2016:

https://www.spinics.net/lists/linux-btrfs/msg60984.html

I was wondering if there was any information available on the "rollout" of the patches linked from that page, and in particular whether they have made it (or will make it) into the V4.9.X kernel version?

I'm currently running on the standard Debian 9 kernel, which is based on the V4.9.X tree (a patched version of 4.9.110 for the current release), and would like to try and find some route to get this issue patched on my system without having to build my own kernel (and hence have to maintain patching all other security issues myself)

If anyone wants the specific kernel trace of the bug to confirm it is the same issue, let me know. Alternatively, I have also asked about the problem on a Debian bug report, which has the trace attached:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=910074

Thanks

Michael

