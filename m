Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35642 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaHDKKE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 06:10:04 -0400
Received: by mail-vc0-f182.google.com with SMTP id hy4so10622945vcb.41
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 03:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <17833067.mzxAL4oqZq@quad>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 11:09:23 +0100
Message-ID: <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 August 2014 10:39, Chris Samuel <chris@csamuel.org> wrote:
> On Mon, 4 Aug 2014 09:14:19 AM Peter Waller wrote:
>> All of this is *very* surprising.
>
> Hmm, it shouldn't be, the ENOSPC issues are well known and have been discussed
> here for years.

I accept that. It's all very well if you read the BTRFS list and/or
are a BTRFS developer. But if you're trying to work it out in the heat
of battle, as we have sysadmins who would have to, there is a
combination of things here that makes it unreasonable and harmful for
production.

I was in a situation where I was getting sporadic ENOSPC and none of
the instructions I could find helped. I did a thorough search of the
wiki and mailing list - I found a plethora of similar sounding
problems and none of the advice given helped.

Our usage is a simple case: no RAID, no subvolumes, no snapshots. We
had >60GiB free and apparently some metadata free.

I still can't find a clear answer to the question "How do I make an
alarm to warn of an impending ENOSPC condition on BTRFS?"

Is that because there is no clear answer?

The nature of "running out of disk space" as a problem means you won't
hit it until you've been using it for a long while, which makes this
problem of the form "a ticking time bomb". Is there no way to make
this operationally easier? or should only BTRFS developers use BTRFS?

I'm breaking the rest out below if you are interested to try and
understand more the problems I was having.

Thanks,

- Peter

More thoughts to illustrate the problems with the existing documentation:

Getting started contains no warning of what's different about free
space compared with other filesystems one might be familiar with:

  https://btrfs.wiki.kernel.org/index.php/Getting_started

The sysadmin guide doesn't appear to mention free space at all:

  https://btrfs.wiki.kernel.org/index.php/SysadminGuide

The FAQ has a question:

  https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

Which starts out "Free space is a tricky concept in Btrfs" but then
doesn't explain it very well. None of the advice given there helped in
my case. There is talk about a mixed mode, but not how to move an
existing filesystem to it. I'm yet to find an explanation of
rebalancing which isn't focussed on what it means for RAID, and it
still isn't crystal clear to me what rebalancing means for
metadata/data on one disk. Rebalancing didn't work in my case. Must I
construct an image of the underlying BTRFS datastructures in my head?
I'm fine if I have to do that, but nowhere makes it clear what mental
tools I need to tackle this.

This link is mentioned by the above but not directly linked to by it
(and has "are" and "is" changed compared with the above text):

https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways_to_check_the_amount_of_free_space.3F

This link would have helped a bit but wasn't cross referenced by any
of the other materials which I did find, so I couldn't find it in the
heat of battle:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space

One problem is that it isn't clear what "chunks" are. Does an operator
of a BTRFS filesystem need to understand this in the simple case of no
snapshots, no RAID?

How did the whole disk come to be allocated to data given that we
hadn't used all of it? Is it because the data is using chunks
inefficiently? How does this come to be in the simple case?

The documentation could use some illustrations to make this clear.
