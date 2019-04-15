Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963A6C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 19:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62A8A2087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 19:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfDOTAQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 15:00:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:47128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728126AbfDOTAQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 15:00:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1CB8BAE56;
        Mon, 15 Apr 2019 19:00:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 96E79DA9C7; Mon, 15 Apr 2019 21:01:20 +0200 (CEST)
Date:   Mon, 15 Apr 2019 21:01:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] cleanup property and extended attribute set
Message-ID: <20190415190117.GA20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190412080259.5192-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412080259.5192-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 12, 2019 at 04:02:53PM +0800, Anand Jain wrote:
> In an attempt to stream line the property and extended attribute set here
> are the few cleanup patches.
> 
>  1/6 to 3/6 are mostly non functional cleanups (except for the conversion
>   to non static function in 3/6) and can be merged together.
>  4/6 removes the readonly root check in btrfs_setxattr() more details in
>   the change log.
>  5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
>   threads with transaction and without transaction respectively, so this
>   patch uses them.
>  6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
>   now btrfs_setxattr_trans() can drop the trans arg.
> 
> Anand Jain (6):
>   btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
>   btrfs: rename do_setxattr to btrfs_setxattr
>   btrfs: declare btrfs_setxattr as a non static function
>   btrfs: remove redundant readonly root check in btrfs_setxattr_trans
>   btrfs: split thread with trans to use btrfs_setxattr
>   btrfs: cleanup btrfs_setxattr_trans drop trans arg

Looks good to me, thanks. The result is very close to what the previous
patchset did. Patchset will go to for-next soon.
