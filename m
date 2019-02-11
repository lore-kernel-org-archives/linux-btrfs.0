Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1BAC4151A
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71E0D2229E
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VQNcyK/h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbfBKSoC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:44:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47550 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732117AbfBKSoC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 13:44:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1BIdItr065616;
        Mon, 11 Feb 2019 18:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=jkGcSgW1aNCTUw7w8trCfuW48GzzkcSV1UEYyuqRUxQ=;
 b=VQNcyK/hnpccX+jg4qU09jGFT4RNcJfErW1vsokLDuwfNzPC/Gv+UCSubijT6SoywD+x
 3BYQWs7osdlOsBNkHWsBl/ahKZxp1+aFCc/cvRfkSlIhf8gwUp2UE7InjkklYZcEoukg
 fM1nxBRlKL0WQLxjBtSa4uZAV5l9s1oJe2NSimdsYdwlWSVHI+bq2Ah/znkFy1HdlF8E
 xv/ryF82uw7fj2Xt0Q6jJF+n395yZ4+9peCQTGJGx+Ni9wW+okkP5F6I0zg8wf3UZ4gk
 IxuJGOw8AmuwaVZALlyNYoBaV99ZlZcTV07IG/ISOLQAg815J4qYGivmflOGSFDowy38 Hg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qhrek7jeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:42:52 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1BIgkOC031502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:42:46 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1BIgjZ5003612;
        Mon, 11 Feb 2019 18:42:45 GMT
Received: from kadam (/41.202.241.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 10:42:45 -0800
Date:   Mon, 11 Feb 2019 21:42:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Silence a static checker locking warning
Message-ID: <20190211183231.GA5436@kadam>
References: <20190209090254.GC4865@kadam>
 <20190211163612.GW2900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211163612.GW2900@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=740 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 05:36:13PM +0100, David Sterba wrote:
> > I have re-written the code though to make it cleaner and
> > to silence the static checkers.
> 
> Maybe there's something new the static checker needs to learn.

Gar.  Yes.  You're right.  I hadn't thought about that read locks could
nest.

regards,
dan carpenter

