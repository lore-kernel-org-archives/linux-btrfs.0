Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E53AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 00:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D74E20652
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 00:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xeG3aqhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfCKAou (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 20:44:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48082 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfCKAou (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 20:44:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2B0dwsE140612;
        Mon, 11 Mar 2019 00:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yLIPjD15Q5m1uy0LL65cuDKTWLB1yeUW65T/sdkHUiU=;
 b=xeG3aqhF1CENEhmMhi1rUmTsTLaeaqCzymwy8HCIBvVmrIt9nzyZCSb7cUKLjO3yhUTB
 wOVzOpWE+157gS4pUCaF/K0q8ziBXloLt/UkBlITr8L+uS6d2HSLJKauMlQAfHO775Af
 VMgIiyqvzEfTc1WyQ4J1QAMykgM/EOT+FfMzfukhXVPmfm8T1JACjPkNUOm6SlFYuL9y
 Cw4tPeaGFYuRaK6FLM9GaXAK6gbaOxbPRuo4QBSQ3wsXdhvcWAB1CjSZjll95EpzM9dv
 vHMCOtqdgzOz26y7o6hE+0CReIgE8X5KmMfCrSh9n0oglEaUub8Bu4FJAL3v1kYrwgl6 dw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2r430ec2cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 00:44:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2B0iigO025275
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 00:44:45 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2B0iiXO023388;
        Mon, 11 Mar 2019 00:44:44 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Mar 2019 17:44:44 -0700
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
 <857277d9-7a16-cea0-13c4-aec74cb77064@oracle.com>
 <0e04dd2c-a7b0-c4ce-6340-79c90578f4b5@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <43ece66b-4fb3-d129-12cc-6416384805d1@oracle.com>
Date:   Mon, 11 Mar 2019 08:44:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <0e04dd2c-a7b0-c4ce-6340-79c90578f4b5@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9191 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110003
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> Frankly bpf makes sense but only as a separate script being
> developed and possibly shared on github or whatnot so that other
> interested people can use it. However, integrating with btrfs-progs
> definitely seems the wrong thing to do.

  The end users will definitely like it to be part of btrfs-progs.
  Just because one less hassle for them.

  More over as these tools are kernel function names dependent, it
  must be in par with kernel function name changes.

  If the tool is not upto date the trouble is passed on to the end user
  or to an maintainer externally. Its messy.

  These are very important tools which would evolve over time, its
  better to keep them with the core btrfs development.

Thanks, Anand
