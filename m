Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62297C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 05:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3328E2087E
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 05:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/Jkjv9u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfAHFQS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 00:16:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfAHFQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 00:16:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x085E9VF143173;
        Tue, 8 Jan 2019 05:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6nQaEKlqY4eSZw4sUbgy+N/eG8cJbNmvoeVhC0iULt8=;
 b=B/Jkjv9upBFdLDZo6KV68/HjahVNH+FEv5NO6JnKKQApV4wyOtn7+C59049Ke0iLH5Ln
 oXO49+NpktXANMUWZSAyIFo0FrYnX5E4edTGe9FtGVvmc9dOCcE0lbCkWXHOgfBD8WOB
 sS4BvQcgcptoPl6y6YRL2OgCTRagxl5xPuEoKLcoUzzLMr0xNqq1WPK1G97PXpmZli6O
 m1t2w49G9J11KH+OEGCciorfjYHStR0dyt/4W1GnYHtQT+AR5vz6WxP9fPUQbFCm+rKg
 h4JhPBsIsZjvl95JgOIK6yd3ghuRbXsBOf2sV7TVgqBOOvy2zaUsBUpeZ+Aysaogbilf fw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ptn7qs736-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jan 2019 05:16:14 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x085GDBE020221
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jan 2019 05:16:13 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x085GCSI010932;
        Tue, 8 Jan 2019 05:16:13 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Jan 2019 21:16:12 -0800
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
 <20190107172816.GX23615@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <f7446cbe-0003-0539-fff6-70cd8ea28ba5@oracle.com>
Date:   Tue, 8 Jan 2019 13:16:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190107172816.GX23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9129 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901080040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/08/2019 01:28 AM, David Sterba wrote:
> On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
>> Adds cli and ioctl to forget a scanned device or forget all stale
>> devices in the kernel.
> 
> I've read my comments to previous postings and I suggested to add more
> ways how to specify the device, eg. by uuid or fsid:devid. Have you
> considered that?

  Right I responded [1],

   [1]
   https://www.spinics.net/lists/linux-btrfs/msg81059.html

  basically.. I like uuid|fsid:devid idea but,
  - we also need to add the ability to list out uuid|fsid:devid which
  are already scanned, such as [2] (in ml since 2015).

   [2]
   https://patchwork.kernel.org/patch/7362881/

  Further, its better to be consistent with other cli too..
  As of now, 'btrfs device delete' supports only <path|devid> we need
  to add uuid.
  IMO it can be a candidate for separate series?
  I checked volume.c it needs refactor and consolidation of function
  which are involved in finding the device.

  This patch-set helps xfstests to test with btrfs as root fs.[3].

   [3]
   https://patchwork.kernel.org/patch/10733641/

Thanks, Anand
