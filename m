Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33120 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbEKE5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 00:57:25 -0400
Received: by igbpi8 with SMTP id pi8so65207726igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 21:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2bd31$990b002e$ebe891e2$76d0f14f@cox.net>
References: <20150510164944.GI16535@merlins.org>
	<pan$2bd31$990b002e$ebe891e2$76d0f14f@cox.net>
Date: Sun, 10 May 2015 22:57:24 -0600
Message-ID: <CAJCQCtTszNWB-XpBZs=Fah-J5NBsuOEbLC2pBFtFujUZnNWQ4Q@mail.gmail.com>
Subject: Re: Are there plans for full btrfs filesystem backups?
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 10, 2015 at 9:55 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Marc MERLIN posted on Sun, 10 May 2015 09:49:44 -0700 as excerpted:
>
>> Are there any plans for a full filesystem send/receive, not just a
>> subvolume send/receive?
>
> Recent discussion suggests yes, tho it's a relatively new plan.
>
> More specifically, the recent discussion seemed to settle around the need
> for a send/receive --recursive option, which would recurse into nested
> subvolumes.  IIRC, the systemd folks requested that for their container
> management, among other things.

That was for snapshot creation and destruction, not send receive.

To me, an exact Btrfs clone suggests only a Btrfs destination at the
moment, because there's no superset functionality elsewhere for
everything in Btrfs to exist. One way to get to an "exact clone" would
be Btrfs seed device to effectively freeze the original, and then
"send" the entire seed somehow rather than just a subvolume.

A btrfs send file on non-Btrfs destinations, is a maybe, the problem
there is no checksums exist in the send file and maybe some other
things (?) but presumably that could be extended so that the file
could be a complete representation of the file system warts and all -
which itself may not be desirable so it's like,  how exactly do we
really want these things to be? Hmm?



-- 
Chris Murphy
