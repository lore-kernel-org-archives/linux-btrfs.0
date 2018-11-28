Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CA2C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 17:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582672081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 17:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 582672081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbeK2EFY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 23:05:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:59778 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728141AbeK2EFY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 23:05:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9610DB0F0;
        Wed, 28 Nov 2018 17:03:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BD463DAC7F; Wed, 28 Nov 2018 18:02:47 +0100 (CET)
Date:   Wed, 28 Nov 2018 18:02:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos
Message-ID: <20181128170247.GW2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <20181128155619.GS2842@twin.jikos.cz>
 <20181128161709.GA9917@glet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128161709.GA9917@glet>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 05:17:09PM +0100, Andrea Gelmini wrote:
> On Wed, Nov 28, 2018 at 04:56:20PM +0100, David Sterba wrote:
> > Thanks, such patches are accepted once in a while when the amount of new
> > typo fixes becomes noticeable.
> 
> About this patch (and the others sent to this m/l), I don't
> care to have them committed with my name.

You've put your time to find and fix the typos so you deserve the
credit. Because you sent them with the signed-off-by line I will use
that and maybe write a short changelog but otherwise I don't see a
reason why you should not be mentioned.

> Feel free to copy/integrate/commit with your/someone else name.

Unless you really want to stay out of the linux git history, I'm somehow
obliged by the development process to stick with the patch author name.

> It's just - probably - the best way to let the real devs to know
> about the typos, but it's not valuable effort that must be
> recognized.

The typos can be annoying and distracting while reading code or prevent
some function names to be greppable (which is usually the reason to fix
them). My first patch to linux was also fixing typos, and see where I am
now :)
