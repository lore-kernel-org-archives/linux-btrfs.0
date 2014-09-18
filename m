Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38755 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbaIRViE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 17:38:04 -0400
Received: by mail-oa0-f45.google.com with SMTP id m1so541396oag.18
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 14:38:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53FC982B.9090608@fb.com>
References: <53FC982B.9090608@fb.com>
Date: Thu, 18 Sep 2014 22:38:03 +0100
Message-ID: <CALOYprVLH2e4Ujp-iN6CTFzTVi1x4VwayRgpvQEkmwNBbNXEWQ@mail.gmail.com>
Subject: Re: Btrfs-progs releases
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26 August 2014 15:22, Chris Mason <clm@fb.com> wrote:
> Hi everyone,
>
> I've just tagged btrfs-progs v3.16.  Like the last few releases, this
> one was prepared by Dave Sterba, who has been wrangling btrfs-progs
> patches for some time now.
>
> Dave has asked to officially take over the btrfs-progs maintenance, and
> I said yes before he could change his mind.  Everyone here is doing a
> fantastic job improving btrfs-progs quality and usability, and making
> Dave the btrfs progs maintainer will make sure these changes get
> out on a regular basis.
>
> Aside from more regular releases, very little will change.  I'm still
> running the kernel releases, and I'm setting up more frequent pushes to
> the kernel integration branch so we can more effectively manage our
> patches for the next merge window.
>
> While Dave is getting his kernel.org accounts setup, I'll keep pushing
> his changes to my btrfs-progs git tree, and create tar balls in the
> usual places.
>
> Once his kernel.org trees are setup, we'll find a way to mirror his
> master copy into my directories.
>
> Thanks for your contributions everyone, please let us know if you have
> any questions.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi David,

Congrats (?) on taking over the btrfs-progs releases!

I was wondering if you could shed some light on the status of the
integration branches. Are these going to be discontinued now that you
are maintaining and tagging the official btrfs-progs releases, or will
they stick around, serving a similar purpose as before?

Cheers,


WorMzy Tykashi
