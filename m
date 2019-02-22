Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BABC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123CA20700
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfBVPhd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:37:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:49818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbfBVPhc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 10:37:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C02CCADA9;
        Fri, 22 Feb 2019 15:37:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39245DAA56; Fri, 22 Feb 2019 16:38:52 +0100 (CET)
Date:   Fri, 22 Feb 2019 16:38:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
Message-ID: <20190222153851.GH9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
 <20190220182544.GZ9874@twin.jikos.cz>
 <0f20234c-5fa7-8059-094d-b12e4e9963d0@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f20234c-5fa7-8059-094d-b12e4e9963d0@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 21, 2019 at 08:37:40AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/21 上午2:25, David Sterba wrote:
> > On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
> >> Patchset can be fetched from github:
> >> https://github.com/adam900710/linux/tree/write_time_tree_checker
> >> Which is based on v5.0-rc1 tag.
> > 
> > Please base the patches on something new, a recent rc is fine (rc6 or
> > rc7 depends what you've tested).
> 
> Any recommended workflow for different timing point?
> E.g. always rebase to latest rc?

It depends on the phase of the development cycle, last released rc is a
good default choice unless you have reasons not to use it. Think about
it as "what does happen when this gets merged to the expected target
branch?". If you send a fix for current master, then it's perfect to use
the last rc in master, or base the patch on the branch that gets pulled
there (eg. misc-4.20).

> My current (and now is proven not proper) workflow is to stick with
> -rc1, and cherry pick known fixes related to test.
> This provides a stable base run to spot regression caused by my patches.

You could use that as a reference point, but when the patches get
merged, it's on a more recent codebase so it's better that you verify
that it works on your side. The rc1 is not a very good base in general
as there are so many changes in the whole kernel that need to stabilize.
