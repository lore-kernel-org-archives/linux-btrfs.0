Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8110C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 05:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87F062147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 05:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VPjGzCDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfBZFGw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 00:06:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfBZFGw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 00:06:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1Q543kv056611;
        Tue, 26 Feb 2019 05:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ycxYOz+WRWYK+w2v78ytdxe3vYA0hF5wPd5ZFPZQXRU=;
 b=VPjGzCDfIcQtYg/pkCbgoZeVfJ0kFwsmEtvMzO9QI3uvEmjbal6SGDwJY6RA6+W3BwjO
 F40+B+1VoYJYjZZTF5tqQyjmy/ZAg/v4ZWeHatworhofhjsVjOOCkLK3YaaXwF8KKLkc
 IKWheK2Tg1VkAOTbfaEVCE+c29j+6fYdAWeODSZEKnXj/mujEhegd8QhJKkDzRUSQ2X/
 Oo3DkH83Z/QVXAKhLp+4IMpg60/Ef/3yIuoKwqYLD+K+8GniE+R7+cfqom0ABGKl0H7R
 kKMPSIivtU/CmLDOFo6h/FOWh0go4v+bHBbIzm95A+/gW0PpBuIEIF0yvigKuwbGkRmt HQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxtrj7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 05:06:47 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1Q56koL002394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Feb 2019 05:06:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1Q56kbp031715;
        Tue, 26 Feb 2019 05:06:46 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Feb 2019 21:06:46 -0800
Subject: Re: Btrfs progs release 4.20.2
To:     David Sterba <dsterba@suse.com>
References: <20190225180438.4249-1-dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
Date:   Tue, 26 Feb 2019 13:06:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190225180438.4249-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9178 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902260037
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



  https://patchwork.kernel.org/patch/10732689/

Would like to bring to your notice. Above patch is not yet integrated 
for a long time. Any comments?

Thanks, Anand


On 2/26/19 2:04 AM, David Sterba wrote:
> Hi,
> 
> btrfs-progs version 4.20.2 have been released. This is a quick fix of a problem
> with send/receive path checks that break some setups. As there's no proper
> fix yet, the patch that caused the regression has been reverted.
> 
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> 
> Shortlog:
> 
> David Sterba (5):
>        btrfs-progs: ci: explicitly request reiserfs support for btrfs-convert
>        btrfs-progs: ci: switch to newer build environment
>        Revert "Btrfs-progs: fix mount point detection due to partial prefix match"
>        btrfs-progs: update CHANGES for v4.20.2
>        Btrfs progs v4.20.2
> 
> Nikolay Borisov (1):
>        btrfs-progs: Use a single tab for 'leafsize (deprecated)' row
> 
