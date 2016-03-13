Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35603 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbcCMTmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 15:42:44 -0400
Received: by mail-lb0-f182.google.com with SMTP id bc4so214101999lbc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 12:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
Date: Sun, 13 Mar 2016 20:42:42 +0100
Message-ID: <CAPmG0japAqB2mzBiL=xbkZWwuV8qFTnYX12p9DWh+c5EAGsqGg@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 8:14 PM, Henk Slager <eye1tm@gmail.com> wrote:
> On Sun, Mar 13, 2016 at 12:58 PM, Marc Haber
> <mh+linux-btrfs@zugschlus.de> wrote:
>> Hi,
>>
>> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>>> The alternative if this can't be fixed, is to recreate the filesystem
>>> because there's no practical way yet to migrate so many snapshots to a
>>> new file system.
>>
>> I recreated the file system on March 7, with 200 GiB in size, using
>> btrfs-tools 4.4. The snapshot-taking process has been running since
>> then, but I also regularly cleaned up. The number of snapshots on the
>> new filesystem has never exceeded 1000, with the current count being
>> at 148.
>
> Is the snapshotting still read-write?
> You mentioned earlier that you treated the snapshots as read-only, so
> maybe create them also as read-only, in an attempt to mitigate the
> problem of growing metadata and enospc issues.

Sorry, I mixed it up with another thread; Forget about the question.
