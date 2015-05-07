Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35032 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbbEGEuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 00:50:14 -0400
Received: by igbyr2 with SMTP id yr2so149979841igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 21:50:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20150506T155438-123@post.gmane.org>
References: <loom.20150506T155438-123@post.gmane.org>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 7 May 2015 14:49:53 +1000
Message-ID: <CAB3_QuJ3xkt+5bchszU7rOYMHsym151Lc49L=7Hwt08zqoYmsg@mail.gmail.com>
Subject: Re: btrfs send using with copied snapshot
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Disclaimer: I am just a btrfs user, not an expert.

AFAIU btrfs send currently does the incremental diff by comparing the
snapshot to send with the parent specified with "btrfs send -p", but
both of these must exist on a the same, single source filesystem.
AFAIK you cannot make it examine some other btrfs filesystem as part
of this process, that would require some knowledge of, and thus
bi-directional communication with the receiving filesystem (i.e.
reinventing rsync). This would break the "btrfs send | btrfs receive"
idiom which is a one-way, "zero-knowledge" flow of data (and trivially
allows sending/receiving over ssh and other network protocols to
remote hosts, which is a use-case that your desired example cannot
easily work with).

So in summary, for efficient transport and to make use of incremental
snapshots, you should not immediately delete all snapshots on the
source filesystem. You should instead keep at least whichever was the
last snapshot sent to the destination backup filesystem. And so in
this scenario your source filesystem will always have at least one old
snapshot, and during a btrfs send -p it will also have the new
(current) snapshot (which will then become the "old" snapshots after
it's sent).

I hope my explanation makes sense.

On 7 May 2015 at 00:01, sri <toyours_sridhar@yahoo.co.in> wrote:
> btrfs send has option -p to compare 2 snapshots and genereate output of
> diff and if btrfs receive is there it will get the diff.
>
> lets say i have done my first backup
> /b1/s1 is my subvolume and snap1_s1 is first snapshot
>
> ran command:
>
> btrfse send /b1/snap1_s1 | btrfs receive /backup
>
>
> then I will get my backup /backup/snap1_s1
>
> next I have created 2nd snapshot /b1/snap2_s1
>
> why cannot i do below
>
> btrfs send -p /backup/snap1_s1 /b1/snap2_s1 |btrfs receive /backup
>
> both sanp1_s1 and snap2_s2 are readonly
>
> why there is a restriction of all snapshots should be under same root?
> can't I get the diff of copied snapshot i.e /backup/snap1_s1 (never
> changed) to new snapshot /b1/snap2_s1 ??
>
> My case, i may not always keep previous snapshot but i have copied to
> backup using the snapshot.
>
> In this case is there a way to backup only incrementals using backedup
> snapshot subvolume ?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
