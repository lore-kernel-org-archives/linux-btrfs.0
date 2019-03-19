Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C82CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1AA20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QYBKTS3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfCSKAN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41608 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCSKAM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wxt2026926
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=hqray7s0TkuHQHUffyaYMTo84prBM9ymJxlYSlgQbVk=;
 b=QYBKTS3nJ5gIN/Z8njdi7sxwJ68m7cwfqMp5ngcnnW+fBqmX47YnXcltVj8Ar0mzD3tZ
 MByR4+OkMmtrNeWiTYevS5BbQ1n3RXE5wv1cCAvYzoypjHGfnSueFHfBm5iqU5/BDop8
 HiLlvVoC6NFqUEn/XRvPDHT2nV0vfVGZv6iHS1p7lJLO2S5kzdI1Ia/nkcTfBs8tE27G
 4F87KbypC3jEVWCV1FC3uaSONhkePsyzlNagO4EIPWm07rrjV9zUqrdIz2T4dYxfumjV
 TDNDHMXciszgX55aoROwRJ6Qz146RKYbtKfq8r99W86OZXKJHZp9irqc3Z+OLPIfYWBI Tw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2r8pnektp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0AAo028116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:10 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA0AVr018723
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:10 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:09 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/5] readmirror feature
Date:   Tue, 19 Mar 2019 18:00:19 +0800
Message-Id: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

RFC patch as of now, appreciate your comments. This patch set has
been tested.

Function call chain  __btrfs_map_block()->find_live_mirror() uses
thread pid to determine the %mirror_num when the mirror_num=0.
    
The pid based mirror_num extrapolation has following disadvantages
 . A large single-process read IO will read only from one disk.
 . In a worst scenario all processes read accessing the FS could have
       either odd or even pid, the read IO gets skewed.
 . There is no deterministic way of knowing/controlling which copy will
       be used for reading.
 . May see performance variations for a given set of multi process
       workload ran at different times.
    
So we need other types of readmirror policies.
    
This patch introduces a framework so that we can add more policies, and
converts the existing %pid into as a configurable parameter using the
property. And also provides a transient readmirror mount option, so that
this property can be applied for the read io during mount and for
readonly FS.

 For example:
   btrfs property set <mnt> readmirror pid
   btrfs property set <mnt> readmirror ""
   btrfs property set <mnt> readmirror devid<n>

   mount -o readmirror=pid <mnt>
   mount -o readmirror=devid<n> <mnt>

Please note:
 The property storage is an extented attributes of root inode
 (BTRFS_FS_TREE_OBJECTID), the other choice is a new ondisk KEY,
 which is open for comments.

 This patch uses the unused btrfs_device::type, and does not use the
 bitwise ops because as type is u64 and bitwise ops need u32, so we
 need 32bits of the btrfs_device::type. Which is a kind of messy.
 Its open for suggestion for any better way.

Anand Jain (5):
  btrfs: add inode pointer to prop_handler::validate()
  btrfs: add readmirror pid property
  btrfs: add readmirror devid property
  btrfs: add readmirror pid mount option
  btrfs: add readmirror devid mount option

 fs/btrfs/props.c   | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/super.c   | 29 ++++++++++++++++
 fs/btrfs/volumes.c | 29 +++++++++++++++-
 fs/btrfs/volumes.h | 11 ++++++
 4 files changed, 163 insertions(+), 5 deletions(-)

Anand Jain (2):
  btrfs-progs: add helper to create xattr name
  btrfs-progs: add readmirror policy

 props.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 7 deletions(-)
-- 
1.8.3.1
