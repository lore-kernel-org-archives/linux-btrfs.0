Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85988C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 09:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C3CF20652
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 09:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bi5EzLLA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C3CF20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbeJAQOW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:14:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbeJAQOW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 12:14:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w919Y6e3144988;
        Mon, 1 Oct 2018 09:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=N9vhpjfpuhY7ayOJuJL075o/Xra4tLlPlgkK6/TN7FI=;
 b=bi5EzLLAaIeYJLdBQ/Swz3Pi1gywWMstdsJKpT9Ui2OZiZJvUatywseE1uifMjuzzOQH
 G8NAoDjyIhBASW8FcPxmi8+LZKSaQ4+U7RDX2QE6QhBMa2E/JGSysPxnzJGiOfYkUOab
 je1a2tzRTbUwEP9tHEWHh5P16JNwM6QUnsuQxef1HI+9EN4VvLSkvc57DXp3jB3kD1ji
 SyBgbhOlocjbor6XZveztsVdnYCw9gQOaEyy61DfLfRbCBT/MpN4J/IUmLcqMhQB2dyH
 cA0V3xk2baBZOe5IGLlkZ4wxZ3V6NI6wfOzNHFMRncelZvVS9+h5WNuybW74v8OPOA1B cA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mt0ttdw94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Oct 2018 09:37:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w919bRcq017741
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Oct 2018 09:37:27 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w919bRR2009849;
        Mon, 1 Oct 2018 09:37:27 GMT
Received: from [172.20.10.2] (/183.90.36.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Oct 2018 02:37:26 -0700
Subject: Re: [PLEASE Ignore] [PATCH] verify hardening agaist duplicate fsid
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <1538382592-1632-1-git-send-email-anand.jain@oracle.com>
Message-ID: <14cf406e-52b5-c8bd-ac69-111a18e39cc3@oracle.com>
Date:   Mon, 1 Oct 2018 17:36:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1538382592-1632-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9032 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=855
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810010098
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Please ignore this patch. Instead help review/integrate [1] which is
the same patch with subject and change log updated.

[1]
[PATCH] fstests: btrfs verify hardening agaist duplicate fsid

Thanks, Anand
