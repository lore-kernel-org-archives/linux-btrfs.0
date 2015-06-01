Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34904 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbFAM56 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 08:57:58 -0400
Received: by igbyr2 with SMTP id yr2so60548371igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 05:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mkhjkp$hgl$1@ger.gmane.org>
References: <mkhjkp$hgl$1@ger.gmane.org>
Date: Mon, 1 Jun 2015 13:57:56 +0100
Message-ID: <CAO5K3OfGP6SxK0Ch9XSu1dGZgjEx8G7-b19+2m0tGHzpjY++Zg@mail.gmail.com>
Subject: Re: [newb] move /home to subvolume
From: Vytautas D <vytdau@gmail.com>
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as far as I know, you can't do this, you need to temporary move /home
somewhere else, create /home subvolume and copy everything back.

-
Vytas

On Mon, Jun 1, 2015 at 1:36 PM, Neal Becker <ndbecker2@gmail.com> wrote:
> I have everything under /:
>
> sudo btrfs subvolume list /
> ID 257 gen 65795 top level 5 path root
>
> I want to move /home onto it's own subvolume.  I hope I can do this while
> the root device is mounted.
>
> What is the procedure?
>
> I tried first to create a subvolume for /home at the top-level, but couldn't
> figure out the syntax:
>
> [nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home
> [sudo] password for nbecker:
> ERROR: '/home' exists
>
> --
> Those who fail to understand recursion are doomed to repeat it
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
