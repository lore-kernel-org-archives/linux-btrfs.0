Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EAEC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 06:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BD62074B
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 06:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgFIGvF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 02:51:05 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:4711 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbgFIGvE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 02:51:04 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 8 Jun 2020 23:51:02 -0700
Received: from vikash-ubuntu-virtual-machine.eng.vmware.com (unknown [10.197.103.194])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 75837B12E0;
        Tue,  9 Jun 2020 02:51:03 -0400 (EDT)
From:   Vikash Bansal <bvikas@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>, <clm@fb.com>,
        <josef@toxicpanda.com>, <dsterba@suse.com>,
        <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4.19.y 0/2] btrfs: Fix for CVE-2019-18885
Date:   Tue, 9 Jun 2020 12:20:16 +0530
Message-ID: <20200609065018.26378-1-bvikas@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: bvikas@vmware.com does not
 designate permitted sender hosts)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

CVE Description:
NVD Site Link: https://nvd.nist.gov/vuln/detail?vulnId=CVE-2019-18885

It was discovered that the btrfs file system in the Linux kernel did not
properly validate metadata, leading to a NULL pointer dereference. An
attacker could use this to specially craft a file system image that, when
mounted, could cause a denial of service (system crash).

[PATCH v4.19.y 1/2]:
Backporting of upsream commit 09ba3bc9dd15:
btrfs: merge btrfs_find_device and find_device

[PATCH v4.19.y 2/2]:
Backporting of upstream commit 62fdaa52a3d0:
btrfs: Detect unbalanced tree with empty leaf before crashing

On NVD site link of "commit 09ba3bc9dd150457c506e4661380a6183af651c1" 
was given as the fix for this CVE. But the issue was still reproducible.
So had to apply patch "Commit 62fdaa52a3d00a875da771719b6dc537ca79fce1"
to fix the issue.
