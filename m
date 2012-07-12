Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42896 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2GLF5P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 01:57:15 -0400
Received: by yhmm54 with SMTP id m54so2351702yhm.19
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2012 22:57:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHZ_AjtMe2s+-LpmLNf1rtn7QBtsWk+ANhX9AUDsbCEMDsorOg@mail.gmail.com>
References: <CAHZ_AjtMe2s+-LpmLNf1rtn7QBtsWk+ANhX9AUDsbCEMDsorOg@mail.gmail.com>
Date: Thu, 12 Jul 2012 12:57:14 +0700
Message-ID: <CAG1y0sdiujR5hjXWAL0i5C5M9VG9i_bkoiagZ7h1Bwpuc-S7fw@mail.gmail.com>
Subject: Re: file system corruption removal / documentation quandry
From: "Fajar A. Nugraha" <list@fajar.net>
To: eric gisse <jowr.pi@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2012 at 12:13 PM, eric gisse <jowr.pi@gmail.com> wrote:

> Basically, phoronix showed there is a --repair option. After enabling
> snapshotting and playing around with the various discussed options, I
> discovered that --repair and no special mount options was sufficient
> to get the files removable.

I'm curious, whether running it directly on newer kernel (e.g. latest
ubuntu kernel-ppa/mainline) will be able to "solve" the problem, even
without btrfsck.

Also note that if by "snapshotting" you mean "create LVM snapshots",
then you might be in for another surprise, as btrfs doesn't play nice
with block devices with the same fs UUID. Don't rely on that as backup
option.

>
> Now what I'm hoping for is better documentation on btrfsck even if it
> just boils down to a brief enumeration of the options as that would be
> better than nothing which is what we have now. Do I need to file a bug
> or is this sufficient?

Edit https://btrfs.wiki.kernel.org/index.php/Btrfsck ?

-- 
Fajar
