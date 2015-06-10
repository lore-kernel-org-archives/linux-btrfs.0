Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49469 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964931AbbFJUpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 16:45:54 -0400
Message-ID: <5578A1FA.70400@fb.com>
Date: Wed, 10 Jun 2015 16:45:46 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <adam900710@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com>
In-Reply-To: <557506BC.701@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2015 11:06 PM, Qu Wenruo wrote:
> Hi Chris,
> 
> Please pull the 19 patchset from my branch for_chris_4.2.
> We have tested it in a week.
> 
> Although it is originally based on 4.1-rc5, not the integration branch.
> Quick tests shows no new bugs, although we will rerun the full test,
> I'll send the patchset first for your reviewing:
> 
> https://github.com/adam900710/linux.git for_chris_4.2
> 
> This contains the following patches.
> 
> 1. Qgroup rework (first 18 commits)
> These commits rework the qgroup framework.
> Now, quota won't need to do per-delayed-ref accounting.
> But only need to record dirty delayed-ref, and account quota at
> transaction time.
> 
> The good thing is, at transaction time, we have no other interruption or
> concurrency, account can be quite accurate and only need to account once
> for every dirty extent.(especially faster for shared extents)
> 
> And clearer codes and logic. Codes changes from 1K to 0.5K, even a lot
> of comments are added.
> 

Thanks for preparing all of this! I especially love the comments added.

> With the patchset, btrfs can pass all qgroup test in fstests.
> No longer minus number now.

And the passing xfstests ;)

While I review and test these, I have them at the top of the
integration-4.2 branch.  integration-4.2 may get rebased if I have to
take these out, but I'm trying to use the extra time (Linus plans on an
rc8) to test them as much as possible.

-chris

