Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:36189 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcEMDNU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 23:13:20 -0400
Received: by mail-lb0-f195.google.com with SMTP id le2so2514825lbc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 20:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160510221119.GD7633@wotan.suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
	<20160510221119.GD7633@wotan.suse.de>
Date: Fri, 13 May 2016 11:13:18 +0800
Message-ID: <CAP9B-Qkw065zATZqhMefPcsNBAKPDuaGj6wzN2XMmYZd20fP+Q@mail.gmail.com>
Subject: Re: About in-band dedupe for v4.7
From: Wang Shilong <wangshilong1991@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Guys,

        I am commenting not because of Qu's patch, of course, Qu and Mark Fasheh
Do a really good thing for Btrfs contributions.

        Just my two cents!

1) I think Currently, we should really focus on Btrfs stability, there
are still many
bugs hidden inside Btrfs, please See Filipe flighting patches here and
there. Unfortunately,
I have not seen Btrfs's Bug is reducing for these two years even we
have frozen new features here.
we are adopting Btrfs internally sometime before, but it is really
unstable unfortunately.

So Why not sit down and make it stable firstly?

2)I am not against new feature, but for a new feature, I think we
should be really
careful now,  Especially if a new feature affect normal write/read
path, I think following things can
be done to make things better:

    ->Give your design and documents(maybe put it in wiki or somewhere
else) So that
other guys can really review your design instead of looking a bunch of
codes firstly. And we really
need understand pros and cons of design, also if there is TODO, please
do clarity out how we
can solve this problem(or it is possible?).

   ->We need reallly a lot of testing and benchmarking if it affects
normal write/read path.

   ->I think Chris is nice to merge patches, but I really argue next
time if we want to merge new feautres
Please make sure at least two other guys review for patches.


Thank you!
Shilong

On Wed, May 11, 2016 at 6:11 AM, Mark Fasheh <mfasheh@suse.de> wrote:
> On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
>> Hi, Chris, Josef and David,
>>
>> As merge window for v4.7 is coming, it would be good to hear your
>> ideas about the inband dedupe.
>>
>> We are addressing the ENOSPC problem which Josef pointed out, and we
>> believe the final fix patch would come out at the beginning of the
>> merge window.(Next week)
>
> How about the fiemap performance problem you referenced before? My guess is
> that it happens because you don't coalesce writes into anything larger than
> a page so you're stuck deduping at some silly size like 4k. This in turn
> fragments the files so much that fiemap has a hard time walking backrefs.
>
> I have to check the patches to be sure but perhaps you can tell me whether
> my hunch is correct or not.
>
>
> In fact, I actually asked privately for time to review your dedupe patches,
> but I've been literally so busy cleaning up after the mess you left in your
> last qgroups rewrite I haven't had time.
>
> You literally broke qgroups in almost every spot that matters. In some cases
> (drop_snapshot) you tore out working code and left in a /* TODO */ comment
> for someone else to complete.  Snapshot create was so trivially and
> completely broken by your changes that weeks later, I'm still hunting a
> solution which doesn't involve adding an extra _commit_ to our commit.  This
> is a MASSIVE regression from where we were before.
>
> IMHO, you should not be trusted with large features or rewrites until you
> can demonstrate:
>
>  - A willingness to *completely* solve the problem you are trying to 'fix',
>    not do half the job which someone else will have to complete for you.
>
>  - Actual testing. The snapshot bug I reference above exists purely because
>    nobody created a snapshot inside of one and checked the qgroup numbers!
>
> Sorry to be so harsh.
>    --Mark
>
> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
