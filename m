Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932740AbcJ1PUJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:20:09 -0400
Date: Fri, 28 Oct 2016 17:20:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Divya Indi <divya.indi@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        ashish.samant@oracle.com, bo.li.liu@oracle.com
Subject: Re: [PATCH 3/3] btrfs-progs: Add command to check if balance op is
 req
Message-ID: <20161028152005.GJ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-4-git-send-email-divya.indi@oracle.com>
 <c451366c-089c-5fe0-bfdb-ba3941f79d9d@cn.fujitsu.com>
 <84b80642-1c56-127c-ce1c-e38fd3bf0043@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <84b80642-1c56-127c-ce1c-e38fd3bf0043@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 10:08:23AM -0700, Divya Indi wrote:
> On 10/17/2016 06:42 PM, Qu Wenruo wrote:
> > At 10/18/2016 08:35 AM, Divya Indi wrote:
> >> Add new subcommand to btrfs inspect-internal
> >>
> >> btrfs inspect-internal balance_check <path>
> >> Checks whether 'btrfs balance' can help creating more space (Only
> >> considers data block groups).
> >
> > I didn't think it's good to add a new subcommand just for that.
> >
> > Why not output such relocation sugguestion for you previous bg-analyze 
> > subcommand?
> > (It's better to make it a parameter to trigger such output)
> Or maybe as an option to btrfs balance start?
> Eg: btrfs balance start --check-only <path>

I tend to agree with this approach. The usecase, with some random sample
balance options:

 $ btrfs balance start --analyze -dusage=10 -musage=5 /path

returns if the command would be able to make any progress according to
the given filters and then

 $ btrfs balance start -dusage=10 -musage=5 /path

would actually do that. This is inherently racy, as the analysis will
happen in userspace and the filesystem block group layout could change
in the meantime.

This also implies that the filters are implemented in the userspace,
duplicating the kernel code. This is not neccesarily bad, as this would
work even on older kernels (with new progs), compared to a new analysis
mode of balance implemented in kernel.
