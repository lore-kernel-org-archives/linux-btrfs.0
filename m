Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DE4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 13:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D396206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 13:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="13YxEoM0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfCKNtC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:49:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36106 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfCKNtC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 09:49:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BDiQJF155797;
        Mon, 11 Mar 2019 13:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jsLndAJ283vTYBgH8G5Aqt2fKftlatXjV2sDwZ7A++A=;
 b=13YxEoM0p/X0SwxWi+qiH+PvSnP06zf8BsAaqCrN1XMRXGmVOjA1X06TCWZa2Ah8LRjJ
 qhOB3RZFL2FRh7NSmLrWvRibQSKfGL4VOnHt1ZZH9skqN25x+7b0I/VolTHz3KsUXhRR
 YAbzgFFsXASBWE9ZLFHfOU+rWraOzw2End806n0R5qwmcvp3H27mvmQ+zwvJ/jKkJ9lX
 O7JSDGTx+XdQaqlbifZMMAEaRGpXDprcP7lncirHlCrGGzBr27H648mV7Q2a2dwXYxAj
 TL0GWn+McRxFt/A5XjseXS8CEwsWzVTnuVUl1bFqAfXrfBOb+PhhymrpXKwe+vQLr8T5 9g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2r430eey5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 13:48:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2BDmw0I015074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 13:48:58 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2BDmwvK032312;
        Mon, 11 Mar 2019 13:48:58 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 13:48:58 +0000
Subject: Re: [PATCH v4] btrfs-progs: dump-tree: add noscan option
To:     Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
References: <1551336865-9954-1-git-send-email-anand.jain@oracle.com>
 <aab9c700-bb80-9481-3fd6-151872107612@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <23ab3e25-b285-e445-0fce-18607d25d972@oracle.com>
Date:   Mon, 11 Mar 2019 21:49:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <aab9c700-bb80-9481-3fd6-151872107612@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9191 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=834 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110101
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



>> +        if (ret) {
>> +            error("device scan %s: %s", argv[dev_optind],
>> +                   strerror(-ret));
> 
> Nit:
> 
> Should do some change to follow current "%m" style?
> 
> Thanks
> Su

  Ok will change it. Thanks for catching.

Thanks, Anand

