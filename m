Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2073 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbcEMDox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 23:44:53 -0400
Subject: Re: About in-band dedupe for v4.7
To: Wang Shilong <wangshilong1991@gmail.com>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4b7f7a0e-2fc4-8a08-c391-54be1d26ec51@cn.fujitsu.com>
Date: Fri, 13 May 2016 11:44:40 +0800
MIME-Version: 1.0
In-Reply-To: <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Wang Shilong wrote on 2016/05/13 11:13 +0800:
> Hello Guys,
>
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
> we are adopting Btrfs internally sometime before, but it is really
> unstable unfortunately.
>
> So Why not sit down and make it stable firstly?

Make sense.

Although maybe out of your expectation, inband de-dedupe did exposed 
some existing bugs we didn't ever found before.
And they are all reproducible without inband dedupe.

Some examples:
1) fiemap bugs
    Not only one, but at least 2.
    See the recently submitted generic/352 and 353.

    And the fix is already under testing and may come out soon.

2) inode->outstanding_extents problems.
    Currently we use SZ_128M hard coded max extent length for
    non-compressed file extents.
    But if we change the limit to a smaller one, for example, 128K.
    We will have outstanding extents leak, and tons of warning.

    Although it won't affect current codes, it's still better to fix it.
    And we're already testing the fix again.

3) Slow backref walk.
    Already in the comment of backref.c from ancient days, but we didn't
    put much concern until inband dedupe/heavily reflink work load.

Even not that obvious, we are doing our best to stabilizing btrfs during 
the push of inband dedupe.
(While a nitpicking jerk will never see this)

But you are still quite right on this case, we may be in a rush to push it.

>
> 2)I am not against new feature, but for a new feature, I think we
> should be really
> careful now,  Especially if a new feature affect normal write/read
> path, I think following things can
> be done to make things better:

Although the affect to normal routine is limited to minimal.
you're still right, we lacks the overall documentation to explain the 
design which tries to reduce the impact to existing write routine.

>
>     ->Give your design and documents(maybe put it in wiki or somewhere
> else) So that
> other guys can really review your design instead of looking a bunch of
> codes firstly. And we really
> need understand pros and cons of design, also if there is TODO, please
> do clarity out how we
> can solve this problem(or it is possible?).

Right, already planned before but always busy with other fixes.

The case will change in recent 2 month dramatically, as the modification 
to patchset is already minimal, we have time to create/improve the 
documentation now.

Thanks for the remind.

>
>    ->We need reallly a lot of testing and benchmarking if it affects
> normal write/read path.
>
>    ->I think Chris is nice to merge patches, but I really argue next
> time if we want to merge new feautres
> Please make sure at least two other guys review for patches.
>
>
> Thank you!
> Shilong

Thanks for you suggestions, really helps a lot!

Thanks,
Qu


