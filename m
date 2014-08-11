Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:46511 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaHKUvN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 16:51:13 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so7096657lab.20
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 13:51:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <91397890-7031-41AD-8700-B1341D178B3F@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
	<CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
	<CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
	<16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
	<CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
	<51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com>
	<CAL3q7H7MfE84dgfS==HbKE5N9_MiznYM5B6gMN7xQjX5nhKE0Q@mail.gmail.com>
	<A0E5F699-0F52-4CD4-B60E-42010C6C3361@colorremedies.com>
	<6316ceac72f53e0500b28f60ef280ad6@colorremedies.com>
	<91397890-7031-41AD-8700-B1341D178B3F@colorremedies.com>
Date: Mon, 11 Aug 2014 21:51:11 +0100
Message-ID: <CAL3q7H4G6+tBsOJ463q1XgjTqNTG=8jmcFhsXtXhvF9sTNj73Q@mail.gmail.com>
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 9:30 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Aug 11, 2014, at 10:41 AM, lists@colorremedies.com wrote:
>>>>
>>>> https://friendpaste.com/Bgwdjk31P3pZHtArr341G
>>> OK that friendpaste is completely different than the [PATCH v4] email.
>>> # from above URL
>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>> index 6528aa6..95891c0 100644
>
>
> I can confirm that the above patch fixes the reported bug.
>
> I couldn't get this one to apply so it's not tested:
> http://www.spinics.net/lists/linux-btrfs/msg36556.html

It's exactly the same as the diff you tried. The "git am" command is
able to deal with any fuzz while the patch command can't (or not
always at least). That patch is based on the integration branch, while
the diff I pasted (and showed you to generate it) is for the v3.16 tag
from linus' repository.

Thanks for testing and reporting back.

>
>
> Chris Murphy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
