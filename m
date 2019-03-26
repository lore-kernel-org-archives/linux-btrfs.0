Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C203C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 765592070D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfCZPHk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:07:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:54432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfCZPHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 11:07:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D113AD6D
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 15:07:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 522A0DA8A5; Tue, 26 Mar 2019 16:08:50 +0100 (CET)
Date:   Tue, 26 Mar 2019 16:08:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCh v2 2/9] btrfs: tree-checker: Make chunk item checker more
 readable
Message-ID: <20190326150850.GT10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-3-wqu@suse.com>
 <599a681e-4c7d-2f62-e3ae-0b8bced62225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <599a681e-4c7d-2f62-e3ae-0b8bced62225@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 11:41:44AM +0100, Johannes Thumshirn wrote:
> Looks good,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> Although I think it would've been worth to explicitly mention that you
> increased the severity level from error to critical.

Agreed, changelog updated.
