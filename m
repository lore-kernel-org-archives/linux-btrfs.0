Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64783 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaHJE5U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 00:57:20 -0400
Received: by mail-oa0-f42.google.com with SMTP id n16so5208206oag.15
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 21:57:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b3507$daae2ab8$2945c916$3e96ccb9@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev>
	<20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<pan$b3507$daae2ab8$2945c916$3e96ccb9@cox.net>
Date: Sat, 9 Aug 2014 23:57:19 -0500
Message-ID: <CAKcLGm8u_oGqwnCNQsazhVcY2ZC2-kAzATbLA9k+_OUGDVYSHQ@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 9, 2014 at 11:21 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> ....  But from rc5 on thru rc7 or 8 and
> release, unless you're one of the ones still waiting on a bug found
> earlier to be fixed, it's generally quite stable and boring.
>
> So by the time of actual .0 release, it really is quite stable, and no
> longer development kernel.  Sure, Greg KH's stable series kernel releases
> stabilize it further, but that's exactly what they are, stable series,
> not development series, and there's really no development going into it
> generally from rc1 on, tho occasionally something that needs to come
> after everything else is slipped in in the first couple days after rc1,
> but still well before rc2, and the .0 release signifies the end of the
> post development stabilization period such that .0 really is no longer a
> development kernel at all, even if there are a few more weekly stable-
> series updates (about 10, 3.15.10 was announced to be the last one for
> 3.15, with the Friday-released 3.15.9) before support ceases if it's not
> a long-term-stable candidate.
>

I can't say I've observed that to be the case with Btrfs.  I know
there is a core group of developers working very hard on testing the
Btrfs updates in the _rc kernels, but once that .0 kernel hits the
streets, the extra exposure to all the various combinations of
hardware and options has been know to discover new issues.  I think
this is nearly unavoidable given the pace of Btrfs development.
