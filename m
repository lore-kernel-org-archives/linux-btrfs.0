Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34612 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbcCFUhc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 15:37:32 -0500
Received: by mail-io0-f175.google.com with SMTP id m184so112251642iof.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 12:37:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
Date: Sun, 6 Mar 2016 13:37:31 -0700
Message-ID: <CAJCQCtSArZq3nW-zrR--xCa1=0XkKiPWfekL2_wYKvZ7H8XQLg@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 6, 2016 at 1:27 PM, Chris Murphy <lists@colorremedies.com> wrote:

> So if it were me, I'd gather all possible data, including complete,
> not trimmed, logs.

Also include in the bug, the balance script being used. It might be a
contributing factor.

I wonder if the ENOSPC is happening just prior to the point where
balance would free up the unused portion of allocated metadata chunks
and that's why this just keeps getting worse? The balance function is
COW, so I wonder if there are a bunch of failed chunk migrations that
are just accumulating due to the ENOSPC stopping the balance?


Anyway, after collecting all data and btrfs-image, I would blow away
this fs using current kernel and tools. And then go back to the
original workload. I would not pare down the number or frequency of
snapshots. If anything increase it. The idea is to reproduce the bug.
While ENOSPC is a certain indicator the bug is present, it's not the
only possibility. If the metadata chunk allocation substantially
starts to exceed the used amount by say 4x or more after a full
metadata balance, that suggests a problem even if there is no ENOSPC.
Right now total is more than 50x used.


-- 
Chris Murphy
