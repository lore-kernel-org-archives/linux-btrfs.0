Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36438 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcCMTOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 15:14:47 -0400
Received: by mail-lb0-f181.google.com with SMTP id x1so213831262lbj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 12:14:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313115809.GQ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
Date: Sun, 13 Mar 2016 20:14:45 +0100
Message-ID: <CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 12:58 PM, Marc Haber
<mh+linux-btrfs@zugschlus.de> wrote:
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

Is the snapshotting still read-write?
You mentioned earlier that you treated the snapshots as read-only, so
maybe create them also as read-only, in an attempt to mitigate the
problem of growing metadata and enospc issues.
Also, If some part of the OS or tools scans through the snapshot dirs
every now and then with atime creation on, metadata grows without a
real need.
