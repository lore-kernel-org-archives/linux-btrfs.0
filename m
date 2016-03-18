Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbcCRN1I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 09:27:08 -0400
Date: Fri, 18 Mar 2016 14:26:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/5] btrfs-progs: "sub get-default" doesn't work
Message-ID: <20160318132640.GW21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56EB5937.8070208@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56EB5937.8070208@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2016 at 10:26:15AM +0900, Satoru Takeuchi wrote:
> On 2016/03/17 3:29, David Sterba wrote:
> > btrfs-progs 4.5-rc1 have been released. The ETA for final release is this
> > Friday, so please test and report if you find problems. Small fixes or
> > documentation updates are welcome.
> 
> Please apply this patchset. Especially [1/5]~[4/5] fix
> the regressions caused by the following commit.
> 
> commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")
> 
> I read whole this commit carefully and probably fixed
> all problems in this commit by 1a521af, c742deb,
> and this patchset.

All applied, thanks. I've updated the subject lines and did minor code
reformatting.  And thanks for fixing the mess after 176aeca9a148, we
need more ui coverage tests.
