Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42649 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbB1VET (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Feb 2015 16:04:19 -0500
Received: by lbiw7 with SMTP id w7so23351178lbi.9
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2015 13:04:17 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAP6pX27-MzJXj2sJB5ebsU=BWYoWDn41=977LsT6a38ycThH-Q@mail.gmail.com>
References: <CAP6pX26-_bnm-PKz3SQ1C+Xv5biz_e_2w8WX8syNeozUbTgnMw@mail.gmail.com>
	<CAL3q7H6ymZu6xYffdZ-UFP2Pqr4VHEcFpAWf0KbR_Gsd0v_EcA@mail.gmail.com>
	<CAP6pX27-MzJXj2sJB5ebsU=BWYoWDn41=977LsT6a38ycThH-Q@mail.gmail.com>
Date: Sat, 28 Feb 2015 21:04:17 +0000
Message-ID: <CAL3q7H4ShE9=2Z+s4KxoeouHAy1_bV4JM7zvhJq7fQDbE2Zm3w@mail.gmail.com>
Subject: Re: Receive "directory not empty" bug
From: Filipe David Manana <fdmanana@gmail.com>
To: Ames Cornish <ames@cornishes.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 28, 2015 at 7:37 PM, Ames Cornish <ames@cornishes.net> wrote:
> Sending tree data directly to Filipe, due to size and confidentiality...

Thanks Ames.

In the meanwhile I noticed one similar problem with directory renames
and fixed it. I've just sent the patch to the list:

https://patchwork.kernel.org/patch/5906231/

It's likely to fix your issue, even though a quick glance at your logs
seems it can be a slightly different case.

Let me know if it fixes your case.

thanks

>
> Thanks!
>
> -- Ames
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
