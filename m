Return-Path: <SRS0=GeaY=YB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68636C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 11:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C57A2070B
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 11:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfJHLnm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:43:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730530AbfJHLnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Oct 2019 07:43:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4CC65AC8C;
        Tue,  8 Oct 2019 11:43:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 50031DA7FB; Tue,  8 Oct 2019 13:43:55 +0200 (CEST)
Date:   Tue, 8 Oct 2019 13:43:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: block-group: Rework documentation of
 check_system_chunk function
Message-ID: <20191008114355.GO2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        dsterba@suse.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20191008005038.12333-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008005038.12333-1-marcos.souza.org@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:50:38PM -0300, Marcos Paulo de Souza wrote:
> Commit 4617ea3a52cf (" Btrfs: fix necessary chunk tree space calculation
> when allocating a chunk") removed the is_allocation argument from
> check_system_chunk, since the formula for reserving the necessary space
> for allocation or removing a chunk would be the same.
> 
> So, rework the comment by removing the mention of is_allocation
> argument.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Added to misc-next, thanks.
