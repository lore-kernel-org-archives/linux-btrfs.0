Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41300 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeANQMk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 11:12:40 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eakrh-0003Oo-UF
        for linux-btrfs@vger.kernel.org; Sun, 14 Jan 2018 17:10:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Limit on the number of btrfs snapshots?
Date: Sun, 14 Jan 2018 16:10:17 +0000 (UTC)
Message-ID: <pan$ea879$9cee5b55$59eb5ce2$f548492f@cox.net>
References: <CA+-0u-Yp85JieqjcVk3UkPVtF2ppgpiD27wajEvR0Q3pbf2AUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel E. Shub posted on Fri, 12 Jan 2018 16:38:30 -0500 as excerpted:

> A couple of years ago I asked a question on the Unix and Linux Stack
> Exchange about the limit on the number of BTRFS snapshots:
> https://unix.stackexchange.com/q/140360/22724
> 
> Basically, I want to use something like snapper to take time based
> snapshots so that I can browse old versions of my data. This would be in
> addition to my current off site backup since a drive failure would wipe
> out the data and the snapshots. Is there a limit to the number of
> snapshots I can take and store? If I have a million snapshots (e.g., a
> snapshot every minute for two years) would that cause havoc, assuming I
> have enough disk space for the data, the changed data, and the meta
> data?
> 
> The answers there provided a link to the wiki:
> https://btrfs.wiki.kernel.org/index.php/
Btrfs_design#Snapshots_and_Subvolumes
> that says: "snapshots are writable, and they can be snapshotted again
> any number of times."
> 
> While I don't doubt that that is technically true, another user
> suggested that the practical limit is around 100 snapshots.
> 
> While I am not convinced that having minute-by-minute versions of my
> data for two years is helpful (how the hell is anyone going to find the
> exact minute they are looking for), if there is no cost then I figure
> why not.
> 
> I guess I am asking is what is the story and where is it documented.

Very logical question. =:^)

The (practical) answer depends to some extent on how you use btrfs.

Btrfs does have scaling issues due to too many snapshots (or actually the 
reflinks snapshots use, dedup using reflinks can trigger the same scaling 
issues), and single to low double-digits of snapshots per snapshotted 
subvolume remains the strong recommendation for that reason.

But the scaling issues primarily affect btrfs maintenance commands 
themselves, balance, check, subvolume delete.  While millions of 
snapshots will make balance for example effectively unworkable (it'll 
sort of work but could take months), normal filesystem operations like 
reading and saving files doesn't tend to be affected, except to the 
extent that fragmentation becomes an issue (tho cow filesystems such as 
btrfs are noted for fragmentation, unless steps like defrag are taken to 
reduce it).

So for home and SOHO type usage where you might for instance want to add 
a device to the filesystem and rebalance to make full use of it, and 
where when a filesystem won't mount you are likely to want to run btrfs 
check to try to fix it, a max of 100 or so snapshots per subvolume is 
indeed a strong recommendation.

But in large business/corporate environments where there's hot-spare 
standbys to fail-over to and three-way offsite backups of the hot-spare 
and onsite backups, it's not such a big issue, because rather than 
balancing or fscking, such usage generally just fail-overs to the backups 
and recycles the previous working filesystem devices, so a balance or a 
check taking three years isn't an issue because they don't tend to run 
those sorts of commands in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

