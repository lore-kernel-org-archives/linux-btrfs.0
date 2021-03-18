Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148B5C433DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B3064F2B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCRLtm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:49:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53898 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhCRLtO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Mar 2021 07:49:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9C843AC1E;
        Thu, 18 Mar 2021 11:49:13 +0000 (UTC)
Message-ID: <eb04926d5961114c0401a87e32eb7c540efbbc82.camel@suse.de>
Subject: Re: [PATCH 0/1] btrfs-progs: libbtrfsutil: Relicense to LGPLv2.1+
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Neal Gompa <ngompa@fedoraproject.org>, linux-btrfs@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Date:   Thu, 18 Mar 2021 08:46:35 -0300
In-Reply-To: <20210317200144.1067314-1-ngompa@fedoraproject.org>
References: <20210317200144.1067314-1-ngompa@fedoraproject.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2021-03-17 at 16:01 -0400, Neal Gompa wrote:
> This is a patch requesting all substantial copyright owners to sign
> off
> on changing the license of the libbtrfsutil code to LGPLv2.1+ in
> order
> to resolve various concerns around the mixture of code in btrfs-progs
> with libbtrfsutil.
> 
> Each significant (i.e. non-trivial) commit author has been CC'd to
> request their sign-off on this. Please reply to this to acknowledge
> whether or not this is acceptable for your code.
> 
> Neal Gompa (1):
>   btrfs-progs: libbtrfsutil: Relicense to LGPLv2.1+

Acked-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
>  libbtrfsutil/COPYING              | 1130 ++++++++++++---------------
> --
>  libbtrfsutil/COPYING.LESSER       |  165 -----
>  libbtrfsutil/btrfsutil.h          |    2 +-
>  libbtrfsutil/btrfsutil_internal.h |    2 +-
>  libbtrfsutil/errors.c             |    2 +-
>  libbtrfsutil/filesystem.c         |    2 +-
>  libbtrfsutil/python/btrfsutilpy.h |    2 +-
>  libbtrfsutil/python/error.c       |    2 +-
>  libbtrfsutil/python/filesystem.c  |    2 +-
>  libbtrfsutil/python/module.c      |    2 +-
>  libbtrfsutil/python/qgroup.c      |    2 +-
>  libbtrfsutil/python/setup.py      |    4 +-
>  libbtrfsutil/python/subvolume.c   |    2 +-
>  libbtrfsutil/qgroup.c             |    2 +-
>  libbtrfsutil/stubs.c              |    2 +-
>  libbtrfsutil/stubs.h              |    2 +-
>  libbtrfsutil/subvolume.c          |    2 +-
>  17 files changed, 495 insertions(+), 832 deletions(-)
>  delete mode 100644 libbtrfsutil/COPYING.LESSER
> 

