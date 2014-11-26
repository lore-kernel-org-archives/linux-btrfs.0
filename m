Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:56329 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaKZEsn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 23:48:43 -0500
Received: by mail-yh0-f48.google.com with SMTP id i57so970796yha.7
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 20:48:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141126021134.GR17380@hungrycats.org>
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<20141125222126.GQ17380@hungrycats.org>
	<CAJCQCtQUM=viSoPtcJMcyKquYb1DLmEsqBi=p++uXPy63+r3Ow@mail.gmail.com>
	<20141126021134.GR17380@hungrycats.org>
Date: Tue, 25 Nov 2014 21:48:42 -0700
Message-ID: <CAJCQCtRYDzQvzpc=cqFYOLfhfsSWT1QEwJyS+EQzei8oOfCZKg@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 7:11 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> On Tue, Nov 25, 2014 at 03:46:32PM -0700, Chris Murphy wrote:
>> What happens when all btrfs LVs are unmounted, and you lvchange -an
>> the LVs (the pair) you do not want mounted; and then btrfs dev scan;
>> and then mount one of the devices? It should only find the matching LV
>> because the others are deactivated. I know this isn't ideal, but it's
>> better than corruption.
>
> This is one of two possible ways to assemble the btrfs correctly.
> The other is to explicitly name all of the devices when mounting.

OK I didn't realize it was possible to explicitly name all of them,
the last time I'd tried this (about 9 epochs ago) mount didn't
understand being passed two devices before the mount point.

>
> The challenge for the poor end-user (or inexperienced sysadmin) is to
> defeat all the defaults in system installers, initramfs-tools, lvm2,
> udev, etc. to prevent btrfs from destroying a filesystem accidentally.

I agree if it finds two identical volumes it should fail to mount with
some coherent error.

-- 
Chris Murphy
