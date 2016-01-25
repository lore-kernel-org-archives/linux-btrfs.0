Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34098 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbcAYBGg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 20:06:36 -0500
Received: by mail-io0-f170.google.com with SMTP id 1so137111999ion.1
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 17:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
	<CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
	<20160124211700.GF908@breitenfeld.lan>
	<CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
	<20160124221614.GH908@breitenfeld.lan>
	<CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
Date: Sun, 24 Jan 2016 18:06:35 -0700
Message-ID: <CAJCQCtTO3rx+hWNgiasOL9TeiM+gLexa3kbGBN6rE1VwRqPhuA@mail.gmail.com>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2016 at 3:45 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Maybe it's an orphaned item. I don't know much about those, whether
> btrfs check finds or removes them. But you can safely use
> btrfs-debug-tree while the fs is mounted.
>
> btrfs-debug-tree <dev> | grep -A3 -B3 ORPHAN
>
> That'd find object type ORPHAN and item type ORPHAN_ITEM.

OK I guess that's not implemented yet, nevermind.


-- 
Chris Murphy
