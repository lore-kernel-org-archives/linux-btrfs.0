Return-Path: <SRS0=lvGj=Z4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352A5C43603
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Dec 2019 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C41205F4
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Dec 2019 15:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="rNzSQxqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLFPuv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 10:50:51 -0500
Received: from st43p00im-ztdg10073201.me.com ([17.58.63.177]:49617 "EHLO
        st43p00im-ztdg10073201.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbfLFPuv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Dec 2019 10:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1575647450;
        bh=WhnckWmYm78O5OFui68YehPAQNYi+5hI6VyXK4pjLVk=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=rNzSQxqFOEhPsVCHGfojoQay9O+cxK6228Rog1lyhd3cQxdKvu7bdh8O3HOJbYcfX
         uFc6nFljBcu7SdNS7i747HWSPzZNJ30bWpKdjHXQbZP3vzX+V9+z0+Yb78QwlLgkj9
         BAas3JqnjZR5UciQEKchCZmqagRCMeGR+t0/kbdymSROdBA+FhXthNKZ1oacqjmr6e
         vbp33tWpJ9s5f2EDVJLHvIhwPIgnY1r3TwJIYRZ2eFPgcd6jv+EvZ09NRX6yK8H6w/
         pUW98Yb4q226ut4yfB1ZDG/qChOxQHk6gnv9yglyd9cftOSoJR4Kdnb6Jt02FHZFRN
         ERqZcCwBc/0sg==
Received: from [100.98.43.211] (unknown [5.62.51.38])
        by st43p00im-ztdg10073201.me.com (Postfix) with ESMTPSA id 647D1221EFA;
        Fri,  6 Dec 2019 15:50:48 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH] btrfs-progs: Skip device tree when we failed to read it
From:   Christian Wimmer <telefonchris@icloud.com>
In-Reply-To: <2a220d44-fb44-66cf-9414-f1d0792a5d4f@oracle.com>
Date:   Fri, 6 Dec 2019 12:50:45 -0300
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3AC8F533-78A4-4F7C-9E96-2F3ACB7B06B9@icloud.com>
References: <20191206034406.40167-1-wqu@suse.com>
 <2a220d44-fb44-66cf-9414-f1d0792a5d4f@oracle.com>
To:     Anand Jain <anand.jain@oracle.com>
X-Mailer: Apple Mail (2.3601.0.10)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=729 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1912060133
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi folks,

I could not succeed in patching the btrfs yet.=20
Could you give me a hint of how to do?

a) how and where to download the source code?
b) in case that it is not self-explaining, how to compile?

BTW, I installed the latest Manjaro distribution (5.3.12-1-Manjaro) =
because I need copy/past functionality and so on.
btrfs version is v5.3.1
This is good enough?
Will your patch work against this version?

Thanks,

Chris


