Return-Path: <SRS0=ixrC=5W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC0CC2BA17
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F03120678
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgDFSEK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:04:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDFSEK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Apr 2020 14:04:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72DE6B216;
        Mon,  6 Apr 2020 18:04:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1DD90DA726; Mon,  6 Apr 2020 18:11:14 +0200 (CEST)
Date:   Mon, 6 Apr 2020 18:11:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Zheng Wei <wei.zheng@vivo.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2,RESEND] btrfs: fix the duplicated definition of
 'inode_item_err'
Message-ID: <20200406161113.GP5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Zheng Wei <wei.zheng@vivo.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20200316034600.125962-1-wei.zheng@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316034600.125962-1-wei.zheng@vivo.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 16, 2020 at 11:45:57AM +0800, Zheng Wei wrote:
> remove the duplicated definition of 'inode_item_err'
> in the file tree-checker.c
> 
> Signed-off-by: Zheng Wei <wei.zheng@vivo.com>

Thanks, added to devel queue.
