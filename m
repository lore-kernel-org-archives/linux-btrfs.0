Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6C3C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49A052080D
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfBFPQa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:16:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:48872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbfBFPQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 10:16:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE282B65A;
        Wed,  6 Feb 2019 15:16:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 304F1DA823; Wed,  6 Feb 2019 16:15:52 +0100 (CET)
Date:   Wed, 6 Feb 2019 16:15:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190206151551.GB2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190205145753.GR2900@twin.jikos.cz>
 <20190205160302.GA89375@dennisz-mbp>
 <20190205162733.GT2900@suse.cz>
 <20190205163012.GB89375@dennisz-mbp>
 <20190205165113.GU2900@suse.cz>
 <20190205170749.GV2900@suse.cz>
 <20190205182748.GY2900@twin.jikos.cz>
 <20190205183027.GA17870@dennisz-mbp.dhcp.thefacebook.com>
 <20190205204848.GA39186@dennisz-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205204848.GA39186@dennisz-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 03:48:48PM -0500, Dennis Zhou wrote:
> > Ok great! I'm going to add a v2 for 0012 to add taking the spin_lock
> > just to be safe in cleanup. I should have that ready in a few minutes.
> > 
> 
> Before I run v3, are there any other concerns (pending the changes I
> made to address the mentioned make sense)?

You don't needs to do full v3 resend, either new version of the
individual patches or incremental changes that can be squashed to the
patch. I'm about to move the patchset from topic branch to misc-next so
incrementals work better now as there aren't big updates expected.
