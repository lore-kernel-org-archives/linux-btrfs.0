Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86DBC07E85
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 16:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DC420855
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 16:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6DC420855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbeLKQsO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:48:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:48172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726808AbeLKQsO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 11:48:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 62C4DAF93;
        Tue, 11 Dec 2018 16:48:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 64235DA835; Tue, 11 Dec 2018 17:47:51 +0100 (CET)
Date:   Tue, 11 Dec 2018 17:47:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 4/8] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Message-ID: <20181211164751.GN23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181203152459.21630-5-josef@toxicpanda.com>
 <83a7b193-0763-6f7a-611c-deaf0d6c380e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83a7b193-0763-6f7a-611c-deaf0d6c380e@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 11, 2018 at 12:08:23PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 17:24 ч., Josef Bacik wrote:
> > With my change to no longer take into account the global reserve for
> > metadata allocation chunks we have this side-effect for mixed block
> > group fs'es where we are no longer allocating enough chunks for the
> > data/metadata requirements.  To deal with this add a ALLOC_CHUNK_FORCE
> > step to the flushing state machine.  This will only get used if we've
> > already made a full loop through the flushing machinery and tried
> > committing the transaction.  If we have then we can try and force a
> > chunk allocation since we likely need it to make progress.  This
> > resolves the issues I was seeing with the mixed bg tests in xfstests
> > with my previous patch.
> > 
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Imo this and the previous patch should be squashed into one.

I don't see why, separate patches also look good to me. One changes the
logic regarding global reserve and the other fixes behaviour regarding
mixed block groups.

Possibly, if the fix can be applied first and then the overall logic
changed, that's still 2 patches but there's no intermediate state with
the bug. As long as it's not something really disasterous or if the
"one logical thing per patch" is unnecessarily split to 2 patches, I'm
willing to take more patches. This is a bit of a grey zone so if I'm
missing something regarding the split, please let me know.
