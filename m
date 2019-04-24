Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9609FC282E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D4FD21906
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389980AbfDXRZH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 13:25:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:39102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389972AbfDXRZG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 13:25:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84BF3AC31;
        Wed, 24 Apr 2019 17:25:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 305D3DA85E; Wed, 24 Apr 2019 19:26:07 +0200 (CEST)
Date:   Wed, 24 Apr 2019 19:26:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: track odirect bytes in flight
Message-ID: <20190424172605.GC20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-2-josef@toxicpanda.com>
 <044fa7af-3c45-46ba-d15b-fdb606c83a3b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <044fa7af-3c45-46ba-d15b-fdb606c83a3b@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 12, 2019 at 01:17:40PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> > When diagnosing a slowdown of generic/224 I noticed we were wasting a
> > lot of time in shrink_delalloc() despite all writes being O_DIRECT
> > writes.  O_DIRECT writes still have outstanding extents, but obviously
> > cannot be directly flushed, instead we need to wait on their
> > corresponding ordered extent.  Track the outstanding odirect write bytes
> > and if this amount is higher than the delalloc bytes in the system go
> > ahead and force us to wait on the ordered extents.
> 
> This is way too sparse. I've been running generic/224 to try and
> reproduce your slowdown. So far I can confirm that this test exhibits
> drastic swings in performance - I've seen it complete from 30s up to
> 300s. I've also been taking an offcputime[0] measurements in the case
> where high completion times were observed but so far I haven't really
> seen shrink_delalloc standing out.
> 
> Provide more information how you measured the said slowdown as well as
> more information in the changelog about why it's happening. At the very
> least this could be split into 2 patches:
> 
> 1. Could add the percpu counter init + modification in ordered extent
> routines
> 
> 2. Should add the logic in shrink_delalloc. Ideally that patch will
> include detailed explanation of how the problem manifests.

I don't think splitting the init code is required here, I did not find
it distracting while reading the patch.

The 'ideally' part of your comment is be something that we should not
ask for. Missing or vague explanation for change like that is a bad
practice. Josef, please update the changelog and resend, thanks.
