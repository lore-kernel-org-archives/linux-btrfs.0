Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33325 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbbJVIxq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 04:53:46 -0400
Received: by igbkq10 with SMTP id kq10so9696448igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 01:53:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <m49lhavbh8n.fsf@coffee.modeemi.fi>
References: <m49lhavbh8n.fsf@coffee.modeemi.fi>
Date: Thu, 22 Oct 2015 09:53:45 +0100
Message-ID: <CAL3q7H5+BnHoDw3heasPpRw_kXv=rZdOYYFgtj8N39rAjWiY1Q@mail.gmail.com>
Subject: Re: BTRFS BUG at insert_inline_extent_backref+0xe3/0xf0 while rebalancing
From: Filipe Manana <fdmanana@gmail.com>
To: Erkki Seppala <flux-btrfs@inside.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 22, 2015 at 6:32 AM, Erkki Seppala <flux-btrfs@inside.org> wrote:
> Hello,
>
> Recently I added daily rebalancing to my cron.d (after finding myself in
> the no-space-situation), and not long after that, I found my PC had
> crashed over night. Having no sign in the logs anywhere (not even over
> network even though there should be) I had nothing to go on, but this
> night it crashed again after starting the rebalance, and this time there
> was some information on the kernel log.
>
> Kernel version: 4.2.3 (package linux-image-4.2.0-1-amd64 version 4.2.3-1
> from Debian Unstable)
>
> The dump is available at:
>
>   http://www.modeemi.fi/~flux/btrfs/btrfs-BUG-2015-10-55.txt
>
> The log is available as well (stripped some unrelated USB- and firewall
> logging, showing that last evening there was some kernel task hung for
> 120 seconds; but it's in another btrfs filesystem and is another story):
>
>   http://www.modeemi.fi/~flux/btrfs/btrfs-2015-10-55.txt
>
> I'm not quite sure which of the btrfs balance commands caused the
> issue. But there is my script:
>
> #!/bin/sh
> fs="$1"
> if [ -z "$fs" ]; then
>   echo usage: btrfs-balance / 0 1 5 10 20 50
>   exit 1
> fi
> fs="$1"
> shift
> for usage in d m; do for a in "$@"; do date; /bin/btrfs balance start
> "$fs" -v -${usage}usage=$a; done; done
>
> And it was started at 07:30 with:
>
>   /usr/local/sbin/btrfs-balance / 0 1 2 5 10 20 30 50 70
>
> I should add that the filesystem in question is backed by MD RAID10 and
> that is backed by four SSDs, so it's reasonably fast in IO, if that
> affects anything. There should have been no much competing IO at the
> time of the occurrence.
>
> Before Duncan asks ;-), I only have a moderate number of subvolumes and
> snapshots, ie. one subvolume for each of /, /var/log/journal and /home,
> 24 snapshots of / and /home plus <10 snapshots of /.
>
> Before that balance there was another balance on a another BTRFS RAID10,
> but given the time stamp I think I can easily say it wasn't the cause.
>
> I don't really have other 'solutions' than disabling the rebalancing for
> the time being, and only use it as-needed as I had earlier done..

Try this (just sent a few minutes ago):
https://patchwork.kernel.org/patch/7463161/

thanks

>
> Cheers,
>
> --
>   _____________________________________________________________________
>      / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
>     / /_ / // // /\ \/ /                                            \  /
>    /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
