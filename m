Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33806 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbJXRwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Oct 2015 13:52:21 -0400
Received: by iow1 with SMTP id 1so151785262iow.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2015 10:52:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151024173617.GA26012@nbnb1>
References: <20151024173617.GA26012@nbnb1>
Date: Sat, 24 Oct 2015 18:52:21 +0100
Message-ID: <CAL3q7H5H_Qdq0NAhiDOVw=JLYPJPuHhhSZPgUSQm=oYN+yXK=g@mail.gmail.com>
Subject: Re: btrfs double send
From: Filipe Manana <fdmanana@gmail.com>
To: kolcon@kolcon.net
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 24, 2015 at 6:36 PM,  <kolcon@kolcon.net> wrote:
> Hello,
>
> I would like to do backups based on btrfs send/receive.
>
> So I though I would do a transfer over portable HDD and then incremental
> sends (using -p) over network.
>
> Initial :
>
> btrfs send "all" (primary HDD) →  btrfs receive (portable HDD) →  btrfs
> send/receive (final HDD)
>
> Later :
>
> btrfs send -p "all" new →  ssh newhost "btrfs receive … "
>
> But I found out that does not work. It complains parent not found.
>
> Am I doing something wrong, or is it intended behaviour?

It's a bug, we got it recently reported and fixed.
The fix is in Chris' integration branch for the upcoming 4.4 merge window:

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.4&id=b96b1db039ebc584d03a9933b279e0d3e704c528

cheers
>
> Best regards,
>
> Lubos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
