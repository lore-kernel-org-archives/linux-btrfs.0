Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B8DC433E9
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCEA64E62
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355113AbhCDASy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:54 -0500
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:57746 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1582434AbhCCKVi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Mar 2021 05:21:38 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id D3FC0801F9A8
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Mar 2021 09:04:40 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 8ED1B8384368;
        Wed,  3 Mar 2021 09:04:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: stick05_500cdd8276c4
X-Filterd-Recvd-Size: 1969
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed,  3 Mar 2021 09:04:35 +0000 (UTC)
Message-ID: <de354fc597a931c9e55e874a4cac70dc5363248f.camel@perches.com>
Subject: Re: [PATCH v2 08/10] fsdax: Dedup file range to use a compare
 function
From:   Joe Perches <joe@perches.com>
To:     "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "hch@lst.de" <hch@lst.de>, "rgoldwyn@suse.de" <rgoldwyn@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Wed, 03 Mar 2021 01:04:34 -0800
In-Reply-To: <OSBPR01MB2920D986D605EE229E091601F4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
         <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
        ,<aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
         <OSBPR01MB2920D986D605EE229E091601F4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2021-03-03 at 08:45 +0000, ruansy.fnst@fujitsu.com wrote:
> I have re-sent two new patches to fix this(PATCH 08/10)
> and the previous(PATCH 07/10) which are in-reply-to these two patch, please
> take a look on those two.  Maybe I should resend all of the patchset as a
> new one...

That's generally a better mechanism.

Sending new patches as replies to your own patches without
incrementing a version number in the subject can be confusing.


