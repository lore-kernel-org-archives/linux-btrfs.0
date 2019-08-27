Return-Path: <SRS0=Pg1I=WX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E80BC3A5A3
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD212186A
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfH0P1P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:27:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:40358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfH0P1P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Aug 2019 11:27:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B507CAF06
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2019 15:27:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 107ACDA8D5; Tue, 27 Aug 2019 17:27:37 +0200 (CEST)
Date:   Tue, 27 Aug 2019 17:27:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs-progs: mkfs: treat btrfs_add_to_fsid as fatal
 error
Message-ID: <20190827152736.GM2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190814010402.22546-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814010402.22546-1-jeffm@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 13, 2019 at 09:03:58PM -0400, Jeff Mahoney wrote:
> When btrfs_add_to_fsid fails in mkfs we try to close the ctree.  That
> complains that we already have a transaction open.  We should be taking
> the error path and exit cleanly without writing.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I've merged 1-3, splitting some of the patches. Patch 4 is broken for
some of the resize format and can't be trivially fixed. I'll add a test
so we have better coverage for further development.
