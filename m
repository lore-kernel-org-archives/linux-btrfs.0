Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDE0C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 17:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B7622086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 17:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbfBMReF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 12:34:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:34154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732687AbfBMReF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 12:34:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D27CAE4E;
        Wed, 13 Feb 2019 17:34:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32CFFDA8A7; Wed, 13 Feb 2019 18:35:28 +0100 (CET)
Date:   Wed, 13 Feb 2019 18:35:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] btrfs: scrub: fix scrub_lock
Message-ID: <20190213173526.GB9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 02:44:59PM +0800, Anand Jain wrote:
> Fixes the circular locking dependency warning as in patch 1/3,
> and patch 2/3 adds lockdep_assert_held() to scrub_workers_get().
> Patch 3/3 converts scrub_workers_refcnt into refcount_t.
> 
> Anand Jain (3):
>   btrfs: scrub: fix circular locking dependency warning
>   btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
>   btrfs: scrub: convert scrub_workers_refcnt to refcount_t

1-3 + my patch adding the assertions is now in misc-next, will be in
5.1. Thanks.
