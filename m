Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60667 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3A3PJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 10:09:19 -0500
Received: by mail-ob0-f179.google.com with SMTP id un3so1699426obb.24
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 07:09:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130129035216.GC23893@shiny.globalsuite.net>
References: <1359429730-16729-1-git-send-email-bo.li.liu@oracle.com>
	<20130129035216.GC23893@shiny.globalsuite.net>
Date: Wed, 30 Jan 2013 09:09:19 -0600
Message-ID: <CAKcLGm8=D7U_UW55dRCc8NukEivS2VJMWON+izPPtquNyxofvA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix race between snapshot deletion and getting inode
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Mason <chris.mason@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "mitch.harder@sabayonlinux.org" <mitch.harder@sabayonlinux.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 9:52 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Mon, Jan 28, 2013 at 08:22:10PM -0700, Liu Bo wrote:
>> While running snapshot testscript created by Mitch and David,
>> the race between autodefrag and snapshot deletion can lead to
>> corruption of dead_root list so that we can get crash on
>> btrfs_clean_old_snapshots().
>
> Really nice.  Thanks to everyone that hashed this out.
>
> -chris

I've been testing "[PATCH v2] Btrfs: fix race between snapshot
deletion and getting inode" along with "[PATCH v6] Btrfs:
snapshot-aware defrag" using the same work flow that was reproducing
the dead_root list corruptions.

I've been unable to reproduce the error in ~24 hours of testing.

Normally, I'd hit the error within an hour of testing on a single run.
 I've made three separate runs, and let the last run proceed
overnight.

I'll keep using these patches, and let you know if anything turns up.

Thanks for all your work on this patch set.
