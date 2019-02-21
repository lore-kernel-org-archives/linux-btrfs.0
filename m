Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C27C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60F42070B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cEjs0vFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfBUON7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:13:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59284 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfBUON7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 09:13:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1LE9pL6151184;
        Thu, 21 Feb 2019 14:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=tLI02zzX5bHrmNXHbcbp0heITjnG8zF8FjIwLa+Dakw=;
 b=cEjs0vFhrgVHJTRBFseBX35EmV9wYeOi/2EmeveY5xB91paeXyDNnfWcpu7fEUmMv3OH
 btUWMLoEdxkCCsTyUs8ZUQUx4K70sEL8IRVecPV1eR4WEwVhqmr3noMnICBQ/okoKs3n
 RvOIIPCko6uuxroOkj5vFrNBV5mcD1riXRLlgYbcHsBH689jHNcR6laBwtCFkhFxSsur
 pb6oci4PAlJKSeJLkZNJ5FYG+Y9iEll/awvHfGLWr1IjB/QyjITp4pnLsXzOeVzmqduu
 eSF0r2LpwkFTAeRHA801nRaqJ1+9H5OcIQyAeBm7wF5wnpkYaBySCqxJc764JeZ/P+js pA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qp81egc8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 14:13:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1LEDs6d031628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 14:13:55 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1LEDrGg012590;
        Thu, 21 Feb 2019 14:13:54 GMT
Received: from kadam (/197.157.34.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 06:13:53 -0800
Date:   Thu, 21 Feb 2019 17:13:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     wqu@suse.com
Cc:     linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: locking: Add extra check in
 btrfs_init_new_buffer() to avoid deadlock
Message-ID: <20190221141347.GA20330@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=777 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902210104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[ This one is not actually your fault.  It's the core code which is
  confusing.  -dan ]

Hello Qu Wenruo,

The patch b72c3aba09a5: "btrfs: locking: Add extra check in
btrfs_init_new_buffer() to avoid deadlock" from Aug 21, 2018, leads
to the following static checker warning:

	fs/btrfs/extent-tree.c:8556 btrfs_init_new_buffer()
	warn: possible NULL dereference of 'buf'

fs/btrfs/extent-tree.c
    8540 static struct extent_buffer *
    8541 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
    8542 		      u64 bytenr, int level, u64 owner)
    8543 {
    8544 	struct btrfs_fs_info *fs_info = root->fs_info;
    8545 	struct extent_buffer *buf;
    8546 
    8547 	buf = btrfs_find_create_tree_block(fs_info, bytenr);

The btrfs_find_create_tree_block() function either returns
alloc_test_extent_buffer() which returns NULL on error or
alloc_extent_buffer() which returns error pointers on error.  It
confuses static checkers and me also.

    8548 	if (IS_ERR(buf))
    8549 		return buf;
    8550 
    8551 	/*
    8552 	 * Extra safety check in case the extent tree is corrupted and extent
    8553 	 * allocator chooses to use a tree block which is already used and
    8554 	 * locked.
    8555 	 */
--> 8556 	if (buf->lock_owner == current->pid) {
    8557 		btrfs_err_rl(fs_info,
    8558 "tree block %llu owner %llu already locked by pid=%d, extent tree corruption detected",
    8559 			buf->start, btrfs_header_owner(buf), current->pid);
    8560 		free_extent_buffer(buf);

regards,
dan carpenter
