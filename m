Return-Path: <SRS0=F3aj=YY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03DCCA9EC3
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Oct 2019 11:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE7E920862
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Oct 2019 11:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfJaLl4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:41:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:51324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbfJaLlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Oct 2019 07:41:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E029BAF7A;
        Thu, 31 Oct 2019 11:41:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C5436DA783; Thu, 31 Oct 2019 12:42:02 +0100 (CET)
Date:   Thu, 31 Oct 2019 12:42:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: clean up locking name in scrub_enumerate_chunks()
Message-ID: <20191031114202.GF3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191031105501.GB26612@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031105501.GB26612@mwanda>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 31, 2019 at 01:55:01PM +0300, Dan Carpenter wrote:
> The "&fs_info->dev_replace.rwsem" and "&dev_replace->rwsem" refer to
> the same lock but Smatch is not clever enough to figure that out so it
> leads to static checker warnings.  It's better to use it consistently
> anyway.

Both reasons, smatch and code consitency are fine, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
