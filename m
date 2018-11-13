Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63645C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318832251A
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 318832251A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbeKNBCo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:02:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:49630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729244AbeKNBCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:02:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 438D4B132;
        Tue, 13 Nov 2018 15:04:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E6F8CDAD3E; Tue, 13 Nov 2018 16:03:52 +0100 (CET)
Date:   Tue, 13 Nov 2018 16:03:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Message-ID: <20181113150351.GB24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181011151346.GR29418@twin.jikos.cz>
 <98354c0d-2bed-340e-4f8e-734307c82863@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98354c0d-2bed-340e-4f8e-734307c82863@mendix.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 07:40:22PM +0000, Hans van Kranenburg wrote:
> On 10/11/2018 05:13 PM, David Sterba wrote:
> > On Thu, Oct 04, 2018 at 11:24:37PM +0200, Hans van Kranenburg wrote:
> >> This patch set contains an additional fix for a newly exposed bug after
> >> the previous attempt to fix a chunk allocator bug for new DUP chunks:
> >>
> >> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
> >>
> >> The DUP fix is "fix more DUP stripe size handling". I did that one
> >> before starting to change more things so it can be applied to earlier
> >> LTS kernels.
> >>
> >> Besides that patch, which is fixing the bug in a way that is least
> >> intrusive, I added a bunch of other patches to help getting the chunk
> >> allocator code in a state that is a bit less error-prone and
> >> bug-attracting.
> >>
> >> When running this and trying the reproduction scenario, I can now see
> >> that the created DUP device extent is 827326464 bytes long, which is
> >> good.
> >>
> >> I wrote and tested this on top of linus 4.19-rc5. I still need to create
> >> a list of related use cases and test more things to at least walk
> >> through a bunch of obvious use cases to see if there's nothing exploding
> >> too quickly with these changes. However, I'm quite confident about it,
> >> so I'm sharing all of it already.
> >>
> >> Any feedback and review is appreciated. Be gentle and keep in mind that
> >> I'm still very much in a learning stage regarding kernel development.
> > 
> > The patches look good, thanks. Problem is explained, preparatory work is
> > separated from the fix itself.
> 
> \o/
> 
> >> The stable patches handling workflow is not 100% clear to me yet. I
> >> guess I have to add a Fixes: in the DUP patch which points to the
> >> previous commit 92e222df7b.
> > 
> > Almost nobody does it right, no worries. If you can identify a single
> > patch that introduces a bug then it's for Fixes:, otherwise a CC: stable
> > with version where it makes sense & applies is enough. I do that check
> > myself regardless of what's in the patch.
> 
> It's 92e222df7b and the thing I'm not sure about is if it also will
> catch the same patch which was already backported to LTS kernels since
> 92e222df7b also has Fixes in it... So by now the new bug is in 4.19,
> 4.14, 4.9, 4.4, 3.16...
> 
> > I ran the patches in a VM and hit a division-by-zero in test
> > fstests/btrfs/011, stacktrace below. First guess is that it's caused by
> > patch 3/6.
> 
> Ah interesting, dev replace.
> 
> I'll play around with replace and find out how to run the tests properly
> and then reproduce this.
> 
> The code introduced in patch 3 is removed again in patch 6, so I don't
> suspect that one. :)
> 
> But, I'll find out.
> 
> Thanks for testing.

I've merged patches 1-5 to misc-next as they seem to be safe and pass
fstests, please let me know when you have updates to the last one.
Thanks.
