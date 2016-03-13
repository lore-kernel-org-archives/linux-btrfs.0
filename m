Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36227 "EHLO
	mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbcCMNRZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 09:17:25 -0400
Received: by mail-yw0-f170.google.com with SMTP id g3so139487311ywa.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 06:17:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313115809.GQ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
Date: Mon, 14 Mar 2016 00:17:24 +1100
Message-ID: <CALxwgb5oMZWT3v7vLvs_nqZ+eNzUns78yW51mj+N7zbsMf1_MQ@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Andrew Vaughan <andrewjvaughan@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc

On 13 March 2016 at 22:58, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> Hi,
>
> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>> The alternative if this can't be fixed, is to recreate the filesystem
>> because there's no practical way yet to migrate so many snapshots to a
>> new file system.
>
> I recreated the file system on March 7, with 200 GiB in size, using
> btrfs-tools 4.4. The snapshot-taking process has been running since
> then, but I also regularly cleaned up. The number of snapshots on the
> new filesystem has never exceeded 1000, with the current count being
> at 148.
>
<snip>


I'm not a dev, so I'll just thouw out a random, and possibly naive idea.

How much i/o load is this filesystem under?
What type of access pattern(s), how frequent and large are the changes?

Are you still making snapshots every 10m?
How often do you delete old snapshots?  Also every 10m, or do you
delete them in batchs every hour or so?

How long does "btrfs subvolume delete -c <one_snapshot>" take?
What does "time btrfs subvolume delete -C <one_snapshot> ; time btrfs
subvolume sync <mount_point>" print ?

The reason for asking is that even on a lightly loaded filesystem I
have seen btrfs subvolume delete take more than 30 seconds.  On a more
heavily load filesystem  I have seen 5+ minutes before btrfs subvolume
delete had finished.

If you have a high enough i/o load, plus large enough changes per
snapshot, it might be possible to get btrfs into a situation were it
never actually finishes cleaning up deleted snapshots.  (I'm also not
sure what happens if you shutdown or unmount whilst btrfs is still
cleaning up, but I expect the devs thought of that).

Andrew
