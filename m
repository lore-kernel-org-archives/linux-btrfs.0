Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34465 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbbJNUXx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 16:23:53 -0400
Received: by obbda8 with SMTP id da8so49194791obb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 13:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2402569.dCkKzGyGNU@hoefnix>
References: <2402569.dCkKzGyGNU@hoefnix>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 14 Oct 2015 15:23:33 -0500
Message-ID: <CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
To: Sjoerd <sjoerd@sjomar.eu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I would not use Raid56 in production.  I've tried using it a few
different ways but have run in to trouble with stability and
performance.  Raid10 has been working excellently for me.

On Wed, Oct 14, 2015 at 3:19 PM, Sjoerd <sjoerd@sjomar.eu> wrote:
> Hi all,
>
> Is RAID6 still considered unstable so I shouldn't use it in production?
> The latest I could find about a test scenario is more than a year ago
> (http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html)
>
> I want to build a new NAS (6 disks of 4TB) on RAID6 and prefer to use btrfs
> over zfs, but the latter is proven stable and I am unsure about btrfs...
> Main usage for me would be to able to replace 1 or 2 failing (or going to
> fail) drives and be able to extend it in the future with more disks. The data
> on it shouldn't get corrupted unless the building were it's in is destroyed ;)
>
> So should I go for btrfs?
>
> NB: I am running happily a RAID5 btrfs with 4x2TB disks in it, but you'll just
> know the value of the filesystem when something goes wrong. Yes I know RAID5/6
> is not a backup ;)
>
> Cheers,
> Sjoerd
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
