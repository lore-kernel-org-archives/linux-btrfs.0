Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EB8C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F9321872
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfAWRmX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:42:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:38464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfAWRmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:42:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97433B080;
        Wed, 23 Jan 2019 17:42:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3A26DA6F5; Wed, 23 Jan 2019 18:41:48 +0100 (CET)
Date:   Wed, 23 Jan 2019 18:41:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Message-ID: <20190123174146.GV2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
 <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
 <20190123143732.GL202535@sasha-vm>
 <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 03:54:00PM +0000, Hans van Kranenburg wrote:
> On 1/23/19 3:37 PM, Sasha Levin wrote:
> > On Tue, Jan 08, 2019 at 11:52:02PM +0000, Hans van Kranenburg wrote:
> >> Hi Sasha,
> >>
> >> On 1/8/19 8:25 PM, Sasha Levin wrote:
> >>> From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> >>>
> >>> [ Upstream commit baf92114c7e6dd6124aa3d506e4bc4b694da3bc3 ]
> >>>
> >>> Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
> >>> fixed calculating the stripe_size for a new DUP chunk.
> >>
> >> That one also ended up as:
> >>
> >> 4.14-stable
> >> 0136bd7238b2cb8238426af4183ed0b02165c3f9
> >>
> >> 4.9-stable
> >> 8890bae03f4dba1c2292e5445682b556af4e8f1b
> >>
> >> 4.4-stable
> >> 97c3e46ef53748278286fc09dcc30b138d6677c4
> >>
> >> 3.16.57-rc1
> >> f68f46284a199f6837c1d5b94a6ae979a2cc463c
> >>
> >> While hitting the failure condition without adding "crafting" steps to
> >> make it exactly match the scenario is unlikely, it might be good if we
> >> just go all the way back with this regression fix?
> > 
> > What do you mean with "all the way back"?
> 
> Oh, apologies for not using unambigious phrasing.
> 
> I mean, it seems the autoselection only found 92e222df7b in places where
> it's actually called 92e222df7b, and not where it was cherry-picked.
> 
> So, for my own understanding: If I have to do something like this ever
> again, then should I have added it like this inside baf92114c?
> 
> Fixes: 92e222df7b ("btrfs: alloc_chunk: fix DUP stripe size handling")
> Fixes: 0136bd7238 ("btrfs: alloc_chunk: fix DUP stripe size handling")
> Fixes: 8890bae03f ("btrfs: alloc_chunk: fix DUP stripe size handling")
> Fixes: 97c3e46ef5 ("btrfs: alloc_chunk: fix DUP stripe size handling")
> Fixes: f68f46284a ("btrfs: alloc_chunk: fix DUP stripe size handling")

The Fixes: tag should always refer to a commit id in Linus' tree, the
stable tree backports use that for common reference so the individual
commit ids of stable trees are not relevant.
