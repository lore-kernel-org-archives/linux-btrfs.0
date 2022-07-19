Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EACC43334
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jul 2022 04:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiGSELQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 00:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiGSELO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jul 2022 00:11:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE26F3E773
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2022 21:11:12 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGhxva030382
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2022 21:11:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=MwN7dpBk9JqxqSXKD81Lg/lSNoRD6vffsYilGrtE84E=;
 b=FqTtWHDIP/Psh4o9oR4CWnsK3PIzKS9OWYDSDH4+E6mjD0yTB89WbS/muV8QzZKZ82Xq
 f6JY+na6s63LEocpJBOUAg/gSoDyJ8SteYVsrBQpqCi4dwgnvlu9EUOeXvVbNyGTFRS/
 2V5yw1jJlZN3Kn7VMcfDIAudDU1U4deHmYc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcs5krq34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2022 21:11:11 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 21:11:10 -0700
Received: by devvm7778.ftw0.facebook.com (Postfix, from userid 558217)
        id 6A1CA24A8291; Mon, 18 Jul 2022 21:11:00 -0700 (PDT)
From:   Ioannis Angelakopoulos <iangelak@fb.com>
To:     <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 0/5] btrfs: Annotate wait events with lockdep
Date:   Mon, 18 Jul 2022 21:09:50 -0700
Message-ID: <20220719040954.3964407-1-iangelak@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 05Z-AfSd6f-bkb_kkNvXnMS9ZLERp0Wr
X-Proofpoint-ORIG-GUID: 05Z-AfSd6f-bkb_kkNvXnMS9ZLERp0Wr
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

With this patch series we annotate wait events in btrfs with lockdep to
catch deadlocks involving these wait events.

Recently the btrfs developers fixed a non trivial deadlock involving
wait events
https://lore.kernel.org/linux-btrfs/20220614131413.GJ20633@twin.jikos.cz/

Currently lockdep is unable to catch these deadlocks since it does not
support wait events by default.

With our lockdep annotations we train lockdep to track these wait events
and catch more potential deadlocks.

Specifically, we annotate the below wait events in fs/btrfs/transaction.c
and in fs/btrfs/ordered-data.c:

  1) The num_writers wait event
  2) The num_extwriters wait event
  3) The transaction states wait events
  4) The pending_ordered wait event
  5) The ordered extents wait event

Changes from v1:
  1) Added 2 labels in the cleanup code of btrfs_commit_transaction() in
  fs/btrfs/transaction.c so that btrfs_lockdep_release() is not called
  multiple times during the error paths.
  2) Added lockdep annotations for the btrfs transaction states wait
  events.
  3) Added a lockdep annotation for the pending_ordered wait event.
  4) Added a lockdep annotation for the ordered extents wait event.


Ioannis Angelakopoulos (5):
  btrfs: Add a lockdep model for the num_writers wait event
  btrfs: Add a lockdep model for the num_extwriters wait event
  btrfs: Add lockdep models for the transaction states wait events
  btrfs: Add a lockdep model for the pending_ordered wait event
  btrfs: Add a lockdep model for the ordered extents wait event

 fs/btrfs/ctree.h            |  37 ++++++++++++
 fs/btrfs/disk-io.c          |  35 ++++++++++++
 fs/btrfs/free-space-cache.c |  11 ++++
 fs/btrfs/inode.c            |  13 +++++
 fs/btrfs/ordered-data.c     |  21 +++++++
 fs/btrfs/transaction.c      | 108 ++++++++++++++++++++++++++++++++----
 6 files changed, 214 insertions(+), 11 deletions(-)

--=20
2.30.2

