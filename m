Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728420AbeGQJAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 05:00:22 -0400
Subject: Re: [PATCH] btrfs: extent-tree: Check if the newly reserved tree
 block is already in use
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180717074658.22331-1-wqu@suse.com>
 <64ca7ccd-64d2-b5a4-e5fa-4ead145dcd17@suse.com>
 <1ca2ca79-0f76-2ac7-b4b6-5266338a053f@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3d7b535f-5466-3a6b-7a04-99e88b75f0fc@suse.com>
Date: Tue, 17 Jul 2018 11:28:53 +0300
MIME-Version: 1.0
In-Reply-To: <1ca2ca79-0f76-2ac7-b4b6-5266338a053f@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.07.2018 11:24, Qu Wenruo wrote:
> And it's causing problem for certain test cases.
> Please ignore this (at least for now).
> 
> But on the other hand, we indeed have a lot of reports on corrupted
> extent tree, it's possible to hit some corrupted extent tree (Su is
> already exhausted by the corrupted tree reported by Marc)
> 
> So I'm not completely fine with current extent tree error handling.
> I'll try to find some balance in next version.


I agree we need a better OVERALL error handling/detection. Your
tree-checker work IMO is a step in the right direction. What I want is
to prevent ad-hoc checks being sprinkled in the code. Sorry, but that's
not fine. The thing with working on a lot of corruption reports is the
fact each one of them is looked at in isolation so it produces isolated
fixes. Whereas if a step back is taken and the overall error
handling/detection is considered it might turn out a whole class of
corruption could be detected by a single change, otherwise checks upon
checks will be added which just add technical debt.

Considering this, I'm more in favor of extending the tree-checker to be
the central place where errors are detected (of course this is easier
said than done).
