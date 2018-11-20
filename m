Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DD3C4161B
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C7520685
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hiJUN0KE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3C7520685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbeKTWZa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 17:25:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58642 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbeKTWZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 17:25:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAKBsS12022071
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=nOCFU0RHmRflOGPzB5EvRIcCv/raj+r23MUbzRvgzl4=;
 b=hiJUN0KEmvtEcJGl4XjlC4vjfJ1dmKaL8BLtHz0h7kn0mjtPW+syKmi4sLPV/uPWfqOt
 LInmjQ+z/7KPriQtDJSuK+9bqMzRDsZi7/AX7ohUCm99Vrljca069MKILftVU2gXIpd8
 Y7srohvnMnZY9rX4lB/2Y3xf+cmYfp9a6x8JfOvabO+CB22NytCvK2dND0KrT3iVsUFD
 UcryGBvh1NXYdnrvhhG+yS6Io7lQOn34hVza8W2mZJA7QNduMS33ff7l0opDnCEiDp8w
 4JVMkBjr9jmBVJ9+bSwOVztVeSlviTV7jxFMQZPFds54PFCtKqIm+vrXRF0izvFgBa7D Rg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2ntaxq3fya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:42 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAKBufaC004438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:41 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAKBuf71022230
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:41 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 03:56:40 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 0/9 v2] fix warn_on for replace cancel
Date:   Tue, 20 Nov 2018 19:56:14 +0800
Message-Id: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=626
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

These two patches were sent as part of
   [PATCH 0/9 v2] fix replace-start and replace-cancel racing
before but as these aren't integrated so I am sending these again.

The patch [1] which is in misc-next, calls btrfs_dev_replace_finishing()
after replace is canceled, so the ret argument passed to the
btrfs_dev_replace_finishing() is -ECANCEL, which is not a real error.
So these patches quieten the warn and error log if its -ECANCEL.

These should be integrated otherwise we see the WARN_ON and btrfs_error()
after replace cancel.

[1] 
08bdfc3a0611 btrfs: fix use-after-free due to race between replace start and cancel

Anand Jain (2):
  btrfs: quieten warn if the replace is canceled at finish
  btrfs: user requsted replace cancel is not an error
