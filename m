Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6D5C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 18:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A732054F
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 18:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfAGSqs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 13:46:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727364AbfAGSqr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 13:46:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12B1BACA8
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 18:46:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5AD89DA7E8; Mon,  7 Jan 2019 19:46:14 +0100 (CET)
Date:   Mon, 7 Jan 2019 19:46:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Refactor retval handling of
 btrfs_lookup_file_extent in btrfs_get_extent
Message-ID: <20190107184613.GB23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181217083602.10166-1-nborisov@suse.com>
 <20181217083602.10166-4-nborisov@suse.com>
 <20190102170553.GA23615@twin.jikos.cz>
 <a5015ce3-e241-d1d2-4894-2a03bb117f4a@suse.com>
 <003128f5-23cd-e8bd-2e82-5f2894596c97@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003128f5-23cd-e8bd-2e82-5f2894596c97@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 07, 2019 at 04:22:01PM +0100, Johannes Thumshirn wrote:
> On 02/01/2019 18:43, Nikolay Borisov wrote:
> > On 2.01.19 г. 19:05 ч., David Sterba wrote:
> >> This is repeating code and could be simplified ... to the original code.
> > 
> > It does and this is intentional. What I've  strived to do is make the
> > idea of the code obvious and not try to reduce the total line of code.
> > It is a massive improvement given the code which modifies extent_end
> > triggers only in case ret is > 0. I discussed this with Johannes and he
> > agreed with my assessment.
> > 
> >> I'm not sure this patch is an improvement.
> 
> I think it really helps when trying to understand the code.
> 
> This is why the patch was created in the first place, I asked Nik about
> something and we went over the code together.

I've tried to read the new version again with fresh eyes and still don't
see any improvement in readability. Not that the whole function is easy
to follow, quite the opposite, but I'd rather see continued refactoring
that untangles the gotos.

The return codes of btrfs_lookup_file_extent follow the common
btrfs_search_slot pattern < 0 error, 0 found, > 0 not found. And in the
last case there's an adjustment needed. Read the item type, check and
branch if necessary. No surprises there.

The amount of duplicated code is also not something trivial like
a variable asisgnment, there are arguments passed etc.
