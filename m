From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Sun, 06 Mar 2011 13:00:27 -0500
Message-ID: <1299434330-sup-8189@think>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl> <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com> <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com> <1299203447-sup-9359@think> <1299241124-sup-3502@think> <BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl> <AANLkTikFVd3kG4J99BQvVUwb05DRQXLyabsHieeTZCBW@mail.gmail.com> <AANLkTinjtx37eJ+v6WS=Y8z_Brkb9YGq5cZdFP1bVWGB@mail.gmail.com> <BAY156-w342CF81501D00C36A69EABD2C50@phx.gbl> <AANLkTimDvTraBapv18iOf8wmUh8nSnUay2etXvjEv77P@mail.gmail.com> <AANLkTi=gqurEsoMZv+10Np4duOKq4kZf77mTgu6BfkSC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Xin Zhong <thierryzhong@hotmail.com>,
	"xin.zhong" <xin.zhong@intel.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=gqurEsoMZv+10Np4duOKq4kZf77mTgu6BfkSC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-03-05 11:50:14 -0500:
> I've constructed a test patch that is currently addressing all the
> issues on my system.
> 
> The portion of Openmotif that was having issues with page faults works
> correctly with this patch, and gcc-4.4.5 builds without issue.
> 
> I extracted only the portion of the first patch that corrects the
> handling of dirty_pages when copied==0, and incorporated the second
> patch that falls back to one-page-at-a-time if there are troubles with
> page faults.

Just to make sure I understand, could you please post the full combined
path that was giving you trouble with gcc?  We do need to make sure the
pages are properly up to date if we fall back to partial writes.

-chris
