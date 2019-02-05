Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861D1C282CC
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53EED2083B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 16:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbfBEQvw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:51:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:48746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725952AbfBEQvv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 11:51:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A41CDAE88;
        Tue,  5 Feb 2019 16:51:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A96C7DA7E3; Tue,  5 Feb 2019 17:51:13 +0100 (CET)
Date:   Tue, 5 Feb 2019 17:51:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190205165113.GU2900@suse.cz>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205163012.GB89375@dennisz-mbp>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 11:30:12AM -0500, Dennis Zhou wrote:
> > > > Something is wrong, the patchset on top of 5.0-rc5 hangs in test
> > > > btrfs/007, without a stacktrace. V1 was fine and I double checked that
> > > > rc5 itself is fine.
> > > 
> > > Hmmm, well that's awkward. I ran xfstests and that test passed on my
> > > machine. I'll figure out the delta and submit a v3. Thanks David!
> > 
> > It failed on a VM and 2 other physical machines, so it's not somethig
> > related to the testing setup.
> 
> Oh, I wasn't alluding to that. I'm more that sure it's my fault
> somewhere along the line.

Hang on, it's probably caused by fstests, as fssum is busy waiting
somewhere, so it's not even kernel code.

fstests a4235f29f780b15d9e87c0f2446a53b9e69c5e2d -- ok
fstests 6d17c9076fe9d97d2411e5909e6b255e5e721fc3 (master) -- hangs
