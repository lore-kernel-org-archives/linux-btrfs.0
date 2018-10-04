Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F098CC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 08:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF3F213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 08:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EnFK4BPL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAF3F213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbeJDPAF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 11:00:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbeJDPAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 11:00:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9485hqY091448;
        Thu, 4 Oct 2018 08:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=G1oWsKTvIUL4hN7fyKBzpFI5P8ifVQxhPz5KqoMakxE=;
 b=EnFK4BPLy8FumN8UTuYWPSVq6dtLiomChVaZypgs4B/7zleWmNY4q/oUDodq/QQjWjqq
 RL7xoX6rXCMTfmrZED7WCi/yYZr/8B31ffzJuVi/nJ80UhJ+fzvqmWbg4HH/VnBQln9X
 VLpO6uUx1NDlrOipREPi0JUWuqeluY2dHNgZvRJWSLeY3KpW9PlpTONlj1b3/+QboG7B
 z7GdWYNA7u4dODwAkd3082ALxBlhblo7pVO/8nfcaW8v8pQaU05jDz+Oj/0MtYlLVFaW
 2gKesmwQCiIvRz2BsuQC70qFf1GPQIUZvm9npXYz59Moou1KBOAqsEDEtHUI438fM8he mA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mt21radja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Oct 2018 08:07:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9487w35024470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Oct 2018 08:07:59 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9487wgF010105;
        Thu, 4 Oct 2018 08:07:58 GMT
Received: from [10.186.53.176] (/10.186.53.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Oct 2018 08:07:58 +0000
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <0ce061ae-eeb3-a338-02e7-631b3818cb8a@oracle.com>
Date:   Thu, 4 Oct 2018 16:07:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181004054950.11651-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9035 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=790
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810040083
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> we
> already expect log tree root generation always to be super block
> genration + 1.

  This is close to what I was looking for by reading the cover-letter,
  basically  what is the impact/bug by not populating it? but can you
  explain more, I wonder how was check working so long then?

> But it could be later used to detect log tree corruption early.

  If there is no impact/bug its rather a good idea to change this when
  the early log tree corruption detection part is ready. So that there
  is absolute clarity.

  The reason why I am grossly wary is - we have incomplete business
  about how do we handle the write-hole, say raid1 to begin with.

Thanks, Anand
