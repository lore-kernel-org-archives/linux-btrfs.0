Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78F0C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A0A2148D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/1Av7gN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfDXJxH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 05:53:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfDXJxH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 05:53:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3O9nJNO044193;
        Wed, 24 Apr 2019 09:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=FSop89/A2sWa/Ilfdh+XTjlrE//27vFgy1B8H43BkRo=;
 b=U/1Av7gNQAK/+92R2HfJisdWp9yvFpK2NRSGZhDUp6WTaxllL0xt0ejElDR0a4vk770P
 kKQTzOW6E1AW0VEC/EH4YW8WcB2Ott2FtfmtBW3/PCntai7C+UmqXh5PcBhyOlay5pdE
 lglwHsBrQPMgDjUC3av2mCI5mkZzhcYeCRhLlbZzsPOJ5JD8K8jFYzkXo1wHjvuCK3XT
 MJO5cV3NqUVTZw/nG24pRarBRvJwopa2JNxyHtmtS3bDsbJhY9bFCe88tzPfeYC5hNlk
 udx5E6zjRHbxSSzrAwBnDGAQuhifM4Z+I6PAamtZ67SDT6b59Hm1RCWDwY2gaXoqFutb jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ryv2q97n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 09:53:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3O9pJ3v155556;
        Wed, 24 Apr 2019 09:53:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ryrhsjd6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 09:53:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3O9r159003173;
        Wed, 24 Apr 2019 09:53:01 GMT
Received: from mwanda (/105.55.12.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Apr 2019 02:53:01 -0700
Date:   Wed, 24 Apr 2019 12:52:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: get fs_info from block group in
 write_pinned_extent_entries
Message-ID: <20190423141426.GA9375@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=582
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904240083
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=604 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904240083
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello David Sterba,

This is a semi-automatic email about new static checker warnings.

The patch b4c7c5d50791: "btrfs: get fs_info from block group in
write_pinned_extent_entries" from Mar 20, 2019, leads to the
following Smatch complaint:

    fs/btrfs/free-space-cache.c:1052 write_pinned_extent_entries()
    warn: variable dereferenced before check 'block_group' (see line 1047)

fs/btrfs/free-space-cache.c
  1046	{
  1047		struct btrfs_fs_info *fs_info = block_group->fs_info;
                                                ^^^^^^^^^^^^^^^^^^^^
The patch adds a dereference

  1048		u64 start, extent_start, extent_end, len;
  1049		struct extent_io_tree *unpin = NULL;
  1050		int ret;
  1051	
  1052		if (!block_group)
                     ^^^^^^^^^^^
But the old code assumed it could be NULL.

  1053			return 0;
  1054	

See also:
fs/btrfs/free-space-cache.c:1319 __btrfs_write_out_cache() warn: variable dereferenced before check 'block_group' (see line 1295)
fs/btrfs/free-space-cache.c:1295 __btrfs_write_out_cache() error: we previously assumed 'block_group' could be null (see line 1253)

regards,
dan carpenter
