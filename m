Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35379 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbDISGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 14:06:23 -0400
Received: by obbfy7 with SMTP id fy7so26843775obb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 11:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
References: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
Date: Thu, 9 Apr 2015 11:06:23 -0700
Message-ID: <CADw2B2MPwXC8pbS42aaUn2zY9h+KE+cqfY4Wagvu=NuYM9=ykQ@mail.gmail.com>
Subject: Re: mlocate/updatedb and btrfs subvolume mounts
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is disabling PRUNE_BIND_MOUNTS for updatedb really the only solution here?

On Fri, Apr 3, 2015 at 1:07 PM, G. Richard Bellamy
<rbellamy@pteradigm.com> wrote:
> I've just noticed that I'm having issues with finding files using
> "locate" when those files are on btrfs subvolume mounts.
>
> The issue is that updatedb cannot discern the difference between a
> btrfs bind mount and btrfs subvolume [1][2]. This generally means that
> if you're using btrfs subvolume mounts and updatedb at the same time,
> and you want to index those subvolumes, you'll need to set
> PRUNE_BIND_MOUNTS to 0 or "no". And then deal with all the cruft that
> causes.
>
> From the bug above, you can see that the RedHat dev Michal Sekletar is
> out of ideas. I'm not sure if he's reached out here or not... and if
> not, he might welcome some help from the folks on this list.
>
> Regrads,
> Richard
>
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=906591#c3
> [2] http://www.spinics.net/lists/linux-btrfs/msg42510.html
