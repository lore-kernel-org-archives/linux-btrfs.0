Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36424 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbJUUvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 16:51:22 -0400
Received: by ioll68 with SMTP id l68so71483354iol.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 13:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
Date: Wed, 21 Oct 2015 13:51:22 -0700
Message-ID: <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Subject: Re: btrfs-balance causes system-freeze on full disk
From: Kyle Manna <2bluesc@gmail.com>
To: =?UTF-8?Q?Jakob_Sch=C3=BCrz?= <wertstoffe@nurfuerspam.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a number of similar btrfs balance crashes in the past few days,
but the disk wasn't full.  You should try tailing the system logs from
a remote machine when it happens. You'll likely see some bug info
before the system dies and becomes unusable.

The issue I encountered is described @
https://bugzilla.kernel.org/show_bug.cgi?id=105681
ᐧ

On Wed, Oct 21, 2015 at 12:38 PM, Jakob Schürz
<wertstoffe@nurfuerspam.de> wrote:
> Hi there!
>
> Is it possible, what i've recognized now. My system (debian) runs on
> btrfs, and i have a lot of snapshots on my hard-disk.
> Since some days my system freezes totally. I recognized, it always
> happens during btrfs-balance.
>
> So i deleted some of the old snapshots and tried another balance-run.
> Nothing happened... No system-freeze.
>
> System-freeze means: No Keyboard-action. The Mouse is frozen, the screen
> is frozen, no magic-sysreq, no ssh-login.
>
> Can btrfs cause such a freeze??
>
> greez
>
> jakob
> --
> http://xundeenergie.at
> http://verkehrsloesungen.wordpress.com/
> http://cogitationum.wordpress.com/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
