Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E177AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 14:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5FAB20C01
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 14:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zbkoRkjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfBZOhP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 09:37:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48096 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfBZOhP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 09:37:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1QEYO3A133826;
        Tue, 26 Feb 2019 14:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JWi4tVN3uH88Bu82GUrguI0Z0Q1uRDRIt9qEj0iIolY=;
 b=zbkoRkjn3qSFydajCzgETXIugZG6Esgt7qExYpaZ5PKmryABFrORMHjbuTU5DUed5Jga
 hARnNuccBWxLLI9qMAM3lTFPXwnsf3oSNPb3x7cVx8IzCabvIKrpoux+8L9mjG+GonRw
 TEEIMaG4e3BaoGMUOt9hcJyht5+tD8FqrScsRDNlQap060c/dUcv/eUdphA0vnjNE26F
 I41T8UUmZpxQ9Vm2z+sCSFwWgdcszO+VLl0Md7ey8veaNr6bhDRxJLH1D8y7heMQlxiW
 aFTScCcxpEiP3rgU7EzT4x1nBUC5l37vgQpLNb9zQaNflcqVMrH4kVNF9xoy+W30EpXj gw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtupe54mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 14:37:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1QEbB1g028144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 14:37:11 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1QEbBgr008688;
        Tue, 26 Feb 2019 14:37:11 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Feb 2019 06:37:11 -0800
Subject: Re: Btrfs progs release 4.20.2
To:     =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>
References: <20190225180438.4249-1-dsterba@suse.com>
 <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
 <CABB28CzM029Wy6q6OF65M0CUZ59Rv8RQZd6ABCfrgV=eO2t4XA@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <313a2d6e-22b3-bb5d-a859-5840c745d9d8@oracle.com>
Date:   Tue, 26 Feb 2019 22:37:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CABB28CzM029Wy6q6OF65M0CUZ59Rv8RQZd6ABCfrgV=eO2t4XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9178 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902260107
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/26/19 4:51 PM, Tomasz Kłoczko wrote:
> -- Tomasz Kłoczko | Tel: 0774 1209067 | LinkedIn: http://lnkd.in/FXPWxH
> On Tue, 26 Feb 2019 at 05:07, Anand Jain <anand.jain@oracle.com> wrote:
>>
>>    https://patchwork.kernel.org/patch/10732689/
>>
>> Would like to bring to your notice. Above patch is not yet integrated
>> for a long time. Any comments?
> 
> I've been trying that patch and still it fails:

  They are not related. This patch won't fix that, nor it claimed
  to do so.

>      [TEST/fsck]   037-freespacetree-repair
> failed: root_helper umount
> /home/tkloczko/rpmbuild/BUILD/btrfs-progs-v4.20.2/tests//test.img
> test failed for case 037-freespacetree-repair

  Looks like FREE_SPACE_BITMAP is not found in the dump-tree,
  so the test case fails.

> kloczek

