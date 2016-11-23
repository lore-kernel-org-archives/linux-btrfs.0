Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934274AbcKWKbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 05:31:06 -0500
Date: Wed, 23 Nov 2016 11:31:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20161123103100.GP12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
 <20161114121335.GJ12522@suse.cz>
 <426cb2c7-b947-63d1-a8c4-8a575268377f@oracle.com>
 <20161122131631.GM12522@suse.cz>
 <cd34fe14-0fc0-9c31-ee8a-2096585f7b61@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cd34fe14-0fc0-9c31-ee8a-2096585f7b61@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 11:00:49AM +0800, Anand Jain wrote:
> > Preparatory bits are in patches:
> >
> >   btrfs-progs: mkfs: add names of matching sysfs feature names
> >   btrfs-progs: mkfs: enhance feature table
> >   btrfs-progs: mkfs: extend mkfs features with compat, safe and default versions
> 
>   I don't seen these patches in the ML. Looks like it was integrated
>   in 4.8.3.

Yeah the patches and many other from me haven't been sent to the
mailinglist, unless I need input regarding usecase. Sending everything
would increase work for me and most of the patches are boring cleanups
anyway.

> > the core work is not yet done.
> >
> > The original usecase has been extended to allow for selecting features
> > that are compatible, ie. can be mounted, safe, ie. are ok wrt The
> > Status page, and default, ie. automatically selected by mkfs.
> 
> > Additionally to
> > that, a system-wide preset from a config file in /etc.
> 
> 
>   Certainly these patches could have been on (cleanup/enhancement)
>   top of my patches which was sent a year back.

Well, back then I started on top of your patches and found out that I'd
have to rework too much code so it was easier to start from scratch.
