Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754413AbcKVNQg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:16:36 -0500
Date: Tue, 22 Nov 2016 14:16:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20161122131631.GM12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
 <20161114121335.GJ12522@suse.cz>
 <426cb2c7-b947-63d1-a8c4-8a575268377f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <426cb2c7-b947-63d1-a8c4-8a575268377f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 04:54:58PM +0800, Anand Jain wrote:
> On 11/14/16 20:13, David Sterba wrote:
> > On Tue, Nov 08, 2016 at 09:14:39PM +0800, Anand Jain wrote:
> >>   This patch isn't integrated, any idea why ?
> >
> > Because it does not cover all usecases.
> 
>     You have stated one of the use case here
>      https://www.spinics.net/lists/linux-btrfs/msg49391.html
> 
>     which I have it implemented in these patches
>       [PATCH 5/7] btrfs-progs: introduce framework version to features
>       [PATCH 6/7] btrfs-progs: add -O comp= option for mkfs.btrfs
>       [PATCH 7/7] btrfs-progs: add -O comp= option for btrfs-convert
> 
>     was their more ?

Yeah, it turned out there's more.

> > I've committed the preparatory
> > bits from branch where I've been working on that feature so we can
> > actually get to the hard parts.
> 
>   these patch set is a year old as well. are you planning to drop
>   these patches ? the clarity is missing. IMO.

Preparatory bits are in patches:

  btrfs-progs: mkfs: add names of matching sysfs feature names
  btrfs-progs: mkfs: enhance feature table
  btrfs-progs: mkfs: extend mkfs features with compat, safe and default versions

the core work is not yet done.

The original usecase has been extended to allow for selecting features
that are compatible, ie. can be mounted, safe, ie. are ok wrt The
Status page, and default, ie. automatically selected by mkfs. Additionally to
that, a system-wide preset from a config file in /etc.
