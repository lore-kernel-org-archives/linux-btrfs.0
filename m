Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50312 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3LEATQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Dec 2013 19:19:16 -0500
Received: by mail-vc0-f179.google.com with SMTP id ie18so12433423vcb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Dec 2013 16:19:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALnfhZAEg1EgtDmZ6Qka=Ka-oaUmg++3mN3M=qOf5BHtEXXPpA@mail.gmail.com>
References: <CALnfhZDKEs7LeTrHAk3oecJ2oOqo=VJzQqoeEy3qNB92s2CC7A@mail.gmail.com>
	<loom.20131204T162331-814@post.gmane.org>
	<20131204174909.GA6675@fb.com>
	<CALnfhZAEg1EgtDmZ6Qka=Ka-oaUmg++3mN3M=qOf5BHtEXXPpA@mail.gmail.com>
Date: Wed, 4 Dec 2013 19:19:15 -0500
Message-ID: <CALnfhZDW4w4kuLPf1pYEMkW-d_aV+o7tHawbrNi+3JX7jeqzFA@mail.gmail.com>
Subject: Re: btrfs-cleaner leaves CPU pinned to 100%
From: Adam G <adam.gradzki@gmail.com>
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good news:

I recreated the problem by booting with autodefrag enabled and loading
a large VirtualBox image of Windows 8.1. The CPU is pinned to 100%
even after closing the VirtualBox software.

Here is the perf with your suggested configuration:

http://pastebin.ca/2492270

~ Adam Gradzki

On Wed, Dec 4, 2013 at 6:58 PM, Adam G <adam.gradzki@gmail.com> wrote:
> Hi Josef,
>
> I do not have any snapshots at the moment. This is a new filesystem
> created with the 3.12 kernel last week. The filesystem is on a laptop
> that sees very little load on the file system and there is plenty of
> free space available on my two btrfs partitions.
>
> I will reboot with autodefrag enabled in fstab right now to see if I
> can capture the stacktraces for you.
>
> Regards,
> Adam Gradzki
