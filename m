Return-Path: <SRS0=aoAP=7F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE7AC433E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 May 2020 17:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6FA120738
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 May 2020 17:57:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E6gqI+Bn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgEWR5h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 May 2020 13:57:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgEWR5g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 May 2020 13:57:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NHq0I0155269;
        Sat, 23 May 2020 17:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CjI9AVCHfj9Toe4lOhYPDvGyueNErd7wJE2ADjxl8Bo=;
 b=E6gqI+BnoT33zs6u7yUszk+LKaCkvzVtJ3lNKYGeLMlBRVpym44IcNxKNJqthS2AOsc5
 mrF2Btv24FitEDPT45hVH8RrrjEJq0RJRcNZv6a+hqx9jslPxN1MEYiE4eLI+0LM2RcP
 HI4pDfphY0PgabYKsORI6Ca96kqb1I2bZ1W8BNVwVVdmrJi9dVbg1qVVDB4ZEUxMXUvf
 /T7Mu1I5+WrEwbRE9Oi3MBtDBm/XdmWJ4Kk28s5a+GwEvXVoBpwoF6fI/6MY66Zz7wNP
 T2J6XRiZdqhy8qsDmtjvawmz8/df4q1o+9ADplZY6eopvv/jw4BUOz0/TfFcVus7LlAb qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 316uskh9ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 17:57:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NHqkHa147277;
        Sat, 23 May 2020 17:57:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 316rxrxmy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 17:57:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04NHvXLx027682;
        Sat, 23 May 2020 17:57:33 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 10:57:32 -0700
Date:   Sat, 23 May 2020 20:57:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     josef@toxicpanda.com
Cc:     linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: push btrfs_grab_fs_root into btrfs_get_fs_root
Message-ID: <20200523175727.GA105997@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 mlxlogscore=868
 phishscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=10 spamscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 bulkscore=0 mlxlogscore=883 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230149
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello Josef Bacik,

The patch bc44d7c4b2b1: "btrfs: push btrfs_grab_fs_root into
btrfs_get_fs_root" from Jan 24, 2020, leads to the following static
checker warning:

	fs/btrfs/backref.c:565 resolve_indirect_ref()
	warn: 'root' can also be NULL

fs/btrfs/backref.c
  1537  struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
  1538                                       u64 objectid, bool check_ref)
  1539  {
  1540          struct btrfs_root *root;
  1541          struct btrfs_path *path;
  1542          struct btrfs_key key;
  1543          int ret;
  1544  
  1545          if (objectid == BTRFS_ROOT_TREE_OBJECTID)
  1546                  return btrfs_grab_root(fs_info->tree_root);
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1547          if (objectid == BTRFS_EXTENT_TREE_OBJECTID)
  1548                  return btrfs_grab_root(fs_info->extent_root);
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
These return NULL on error and it leads to an OOps in the caller.

  1549          if (objectid == BTRFS_CHUNK_TREE_OBJECTID)
  1550                  return btrfs_grab_root(fs_info->chunk_root);
  1551          if (objectid == BTRFS_DEV_TREE_OBJECTID)
  1552                  return btrfs_grab_root(fs_info->dev_root);
  1553          if (objectid == BTRFS_CSUM_TREE_OBJECTID)
  1554                  return btrfs_grab_root(fs_info->csum_root);
  1555          if (objectid == BTRFS_QUOTA_TREE_OBJECTID)
  1556                  return btrfs_grab_root(fs_info->quota_root) ?
  1557                          fs_info->quota_root : ERR_PTR(-ENOENT);

It should probably return ERR_PTR(-ENOENT).

  1558          if (objectid == BTRFS_UUID_TREE_OBJECTID)
  1559                  return btrfs_grab_root(fs_info->uuid_root) ?
  1560                          fs_info->uuid_root : ERR_PTR(-ENOENT);
  1561          if (objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
  1562                  return btrfs_grab_root(fs_info->free_space_root) ?
  1563                          fs_info->free_space_root : ERR_PTR(-ENOENT);
  1564  again:

regards,
dan carpenter
