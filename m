Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbcEPQlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 12:41:05 -0400
Date: Mon, 16 May 2016 18:40:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160516164037.GF511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 11:13:18AM +0800, Wang Shilong wrote:
>         I am commenting not because of Qu's patch, of course, Qu and Mark Fasheh
> Do a really good thing for Btrfs contributions.
> 
>         Just my two cents!
> 
> 1) I think Currently, we should really focus on Btrfs stability, there
> are still many
> bugs hidden inside Btrfs, please See Filipe flighting patches here and
> there. Unfortunately,
> I have not seen Btrfs's Bug is reducing for these two years even we
> have frozen new features here.

So this means that number of bugs is increasing despite all the bugfixes
taht get merged? I wonder if you have numbers to back that or if it's
just handwaving. Complex code has bugs and it's not easy to discover
them, that's not surprising.

> we are adopting Btrfs internally sometime before, but it is really
> unstable unfortunately.
> 
> So Why not sit down and make it stable firstly?

And do you thing this does not happen? Most of patches that are merged
are fixes or updates related to fixes. The number of new big features is
at most one per release.

> 2)I am not against new feature, but for a new feature, I think we
> should be really
> careful now,  Especially if a new feature affect normal write/read
> path, I think following things can
> be done to make things better:
> 
>     ->Give your design and documents(maybe put it in wiki or somewhere
> else) So that
> other guys can really review your design instead of looking a bunch of
> codes firstly. And we really
> need understand pros and cons of design, also if there is TODO, please
> do clarity out how we
> can solve this problem(or it is possible?).

The design document should come as th 0-th patch in a series. This
patchset had the overall idea described in
1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com, further
comments about details are scattered under the patchset revisions, so
this could be improved so everybody knows what's the consensus.

>    ->We need reallly a lot of testing and benchmarking if it affects
> normal write/read path.

Sure, new tests and test results are welcome but they do not come in
hundreds.

>    ->I think Chris is nice to merge patches, but I really argue next
> time if we want to merge new feautres
> Please make sure at least two other guys review for patches.

Thanks for the advice, but that's nothing new. People willing to do
reviews are scarce and overloaded. More reviews are not a problem,
everybody does it in a different style, the more the better coverage
we'll have in the end.

Doing reviews cannot be forced otherwise the quality would drop,
announcing 'reviewer of the month' would not help either. Everybody who
considers self a frequent contributor and knows some area should be also
self-motivated to review patches that touch it. Reviewing has a positive
educational effect as one has to make sure he understands what the old
code does and how it's going to be changed by the patch. There's usually
overlap with other areas so this slowly extends the expertise which has
a good impact on the developer community etc.

Maintainers do reviews, but not necessarily as deep as another developer
could do, because sometimes it's difficult, or too lengthy to get
familiar (again) with some particular code or code path.  This leads to
slow merging pace or worse merging buggy patches if the review misses
some dark corners.

I think I'm stating the obvious but it should not hurt to repeat this
from time to time.
