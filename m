Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B54C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 03:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1CC20657
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 03:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v0l1Y22M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfCJDIR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Mar 2019 22:08:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfCJDIR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2019 22:08:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2A31xtK107348;
        Sun, 10 Mar 2019 03:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=t0T/59mSJJvQdP7Ky6I5LRRy2ntE4e4Zavg4k6adOgw=;
 b=v0l1Y22M8MQhtmA5SxCKw8pP9o6QHdDdprS3on4qt0e9V3jP6W0h49i+VdVb4U76+7wI
 k8dkzB59ofPGZNh9A8WKDNDonbix9y8HFZWr0Nchb897MvLmfJas/AJEWvbszisg3zFI
 unPD8BWtNAu9899Od1+CT9m+jQfpVtPuxr/uCvQ0ojtjLzZc1jOSlKz3Tn3yZIVBF7Go
 JTVUr5RCL40K/xObbs1pf727qgyFkrgKXM2ADmIp3S1/xE5xUyBjcxxttk3sb7soK/Uj
 zR2fJM90TRrQQ8hJN1vVYBI8OzLG1Zu/25YfFcXWyyoO5kbA48cn1zQkFe52vAbi26kO lQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r44wtt07g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Mar 2019 03:08:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2A38CKr016998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Mar 2019 03:08:12 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2A38BuN002199;
        Sun, 10 Mar 2019 03:08:11 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Mar 2019 19:08:11 -0800
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <857277d9-7a16-cea0-13c4-aec74cb77064@oracle.com>
Date:   Sun, 10 Mar 2019 11:08:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190306061907.29685-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9190 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=983 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903100022
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> This RFC patchset provides a btrfs specific performance profiler.
> It calculates certain function duration and account the duration.

  I agree we need btrfs specific performance measurements and its
  my list too.

  However my idea was to add it as a btrfs-progs subcommand such as

    btrfs inspect perf ...

  And implement by using the systemtap/perf/bpf/dtrace, as these
  can tap the kernel functions from the useland using which we
  can measure the time taken and no kernel changes will be required.
  But yes we need to update the btrfs-progs if we rename the kernel
  function, which I think is ok.

  I was too early trying this with bpf before, probably there are
  more tools now to do that same thing.

Thanks, Anand

