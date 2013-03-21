Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:56817 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab3CUP1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:27:23 -0400
Received: by mail-qe0-f51.google.com with SMTP id nd7so1904923qeb.10
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 08:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Thu, 21 Mar 2013 16:27:02 +0100
Message-ID: <CAGy7UthyO875AN1_GoeErfvssZVHOUxh58gdDgM_Ewc_JVPN5Q@mail.gmail.com>
Subject: Re: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
To: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

On Sun, Mar 10, 2013 at 1:17 PM, Goffredo Baroncelli
<goffredo.baroncelli@yahoo.com> wrote:
> Unfortunately I noticed a regression which passed all the reviews until now:
> the command btrfs fi df previous didn't require the root capability,
> now with my patches it is required, because I need to know some info
> about the chunks so I need to use the "BTRFS_IOC_TREE_SEARCH".
>
> I think that there are the following possibilities:
> 1) accept this regresssion
> 2) remove the command "btrfs fi df" and leave only "btrfs fi disk-usage" and
>    "btrfs dev disk-usage"
> 3) adding a new ioctl which could be used without root capability. Of course
>    this ioctl would return only a subset of the BTRFS_IOC_TREE_SEARCH info

I'd like to vote for option 1) here. "btrfs fi df" gives useful,
condensed information that I can't get from the others at first
glance. I'd argue that many read-only, informational functions of the
btrfs utility already require root privileges even where that might
not be strictly necessary from a security point of view.

I'd also like to bump this thread in the hope that, if no one else
steps up with new, specific problems, we can now merge this patchset.
We can keep bikeshedding about the display details forever, but I
really think this is a significant improvement over what we had
previously.

Regards,

Bart
