Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A388C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 209112081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ccy+g+CE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 209112081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbeKGVNf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbeKGVNf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7Bf6wM115005
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=rVcbqfYZ8tjPWM48yzS/rhCjzDsfRk1KM8jV19Ujfpk=;
 b=Ccy+g+CENkTDYGZAop0jHpu19vAw+FL+PUgD2LZgDS/fEKKykn+0tSkil3AXgek6txNS
 EHtI1E1OYwCK8PTIPZUmLzMIigHwCTQj50fmPiU2EB8dg7dlxSbpuI48Gmi7wdY0HeP9
 JSQHZiuAbQtDcTXqJw92AgNc4lYUvEjfod7jYRbSsEZrXQTb/WGJD0b3dhQMp7L8cyxf
 EfFKrbtsRXIttc+myTwmW6k/ij1ZU/Ir2sVqGWp0zCWf6Lm0SdtsTtWaWYB9JxhW9pA6
 8L1baxch9L74BPHDgstf7m9VjiRnwuRmwxSh/6i/0AzKufFCJVEcGzN7EsaiZojJ+BpQ HQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2nh4aqtuxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:34 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhWq8032608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:33 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA7BhWeR027871
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:32 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:32 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] fix replace-start and replace-cancel racing
Date:   Wed,  7 Nov 2018 19:43:21 +0800
Message-Id: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace-start and replace-cancel threads can race to create a messy
situation leading to UAF. We use the scrub code to write
the blocks on the replace target. So if we haven't have set the
replace-scrub-running yet, without this patch we just ignore the error
and free the target device. When this happens the system panics with
UAF error.

Its nice to see that btrfs_dev_replace_finishing() already handles
the ECANCELED (replace canceled) situation, but for an unknown reason
we aren't using it to cleanup the replace cancel situation, instead
we just let the replace cancel ioctl thread to cleanup the target
device and return and out of synchronous with the scrub code.

This patch 4/9, 5/9 and 6/9 uses the return code of btrfs_scrub_cancel()
to check if the scrub was really running. And if its not then shall
return an error to the user (replace not started error) so that user
can retry replace cancel. And uses btrfs_dev_replace_finishing() code
to cleanup after successful cancel of the replace scrub.

Further, a suspended replace, when tries to restart, and if it fails
(for example target device missing, or excl ops running) it goes to the
started state, and so the cli 'btrfs replace status /mnt' hangs with no
progress. So patches 2/9 and 3/9 fixes that.

As the originals code idea of ECANCELED was limited to the situation of
the error only and not user requested, there are unnecessary error log
and warn log which 7/9 and 8/9 patches fixes.

Patches 1/9 and 9/9 are good to have fixes. Makes a function static and
code readability good.

Testing: (I did some attempt to convert these into xfstests but need a
mechanism where kernel thread can wait for user land script. I thought
I could do it using ebfp, but needs more digging on how).
As of now hand tested with using procfs to hold kernel thread at
(wait_for_user(..)) until user land issues go.


1.
umount /btrfs; wipefs -a /dev/sd[b-f] && mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs && fillfs /btrfs 10000
btrfs replace start /dev/sdb /dev/sdc /btrfs
  wait_for_user("scrub running is set..waiting"); AND OR
  wait_for_user("scrub running is NOT set..waiting");
btrfs replace cancel /btrfs
  wait_for_user_go();
btrfs replace status /btrfs

2.
umount /btrfs; wipefs -a /dev/sd[b-f] && mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs && fillfs /btrfs 10000
btrfs replace start /dev/sdb /dev/sdc /btrfs
  wait_for_user("scrub running is set..waiting"); AND OR
  wait_for_user("scrub running is NOT set..waiting");
reboot
mount -o device=/dev/sdc /dev/sdb /btrfs
  wait_for_user_go();
btrfs replace status /btrfs
btrfs replace cancel /btrfs
btrfs replace status /btrfs

3.
umount /btrfs; wipefs -a /dev/sd[b-f] && mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs && fillfs /btrfs 10000
btrfs replace start /dev/sdb /dev/sdc /btrfs
  wait_for_user("scrub running is set..waiting"); AND OR
  wait_for_user("scrub running is NOT set..waiting");
reboot
mount -o degraded /dev/sdb /btrfs
btrfs replace status /btrfs
btrfs replace cancel /btrfs
btrfs replace status /btrfs
umount /btrfs
mount /dev/sdb /btrfs


Anand Jain (9):
  btrfs: mark btrfs_dev_replace_start() as static
  btrfs: replace go back to suspended if target missing
  btrfs: replace back to suspend state if EXCL OP is running
  btrfs: fix UAF due to race between replace start and cancel
  btrfs: replace cancel is successful if scrub cancel is successful
  btrfs: replace's scrub must not be running in replace suspended state
  btrfs: quiten warn if the replace is canceled at finish
  btrfs: user requsted replace cancel is not an error
  btrfs: add explicit check for replace result no error

 fs/btrfs/dev-replace.c | 90 ++++++++++++++++++++++++++++++++++----------------
 fs/btrfs/dev-replace.h |  3 --
 2 files changed, 62 insertions(+), 31 deletions(-)

-- 
1.8.3.1

