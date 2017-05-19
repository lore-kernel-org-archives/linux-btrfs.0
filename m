Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750728AbdESN1H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:27:07 -0400
Date: Fri, 19 May 2017 15:26:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/2] btrfs: allow mechanism to override quota
Message-ID: <20170519132608.GV4065@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>
 <20170512144818.GI27439@twin.jikos.cz>
 <CAMp4zn8AZtYs21Cf-6_kfRjGS0khe5ScpEe__H6XC4i-Ci=ZQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMp4zn8AZtYs21Cf-6_kfRjGS0khe5ScpEe__H6XC4i-Ci=ZQw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 01:39:49AM -0700, Sargun Dhillon wrote:
> On Fri, May 12, 2017 at 7:48 AM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, May 11, 2017 at 09:17:01PM +0000, Sargun Dhillon wrote:
> >> This patchset makes it so that on a per-filesystem basis one can disable
> >> quota enforcement for users with cap_sys_resource. This patchset can
> >> likely later be extended to per-qgroup, or a per-volume basis. I'm
> >> thinking of extending the sysfs interface to list the qgroups and
> >> this same interface for the qgroups themselves.
> >>
> >> Changes since v1:
> >>   -Rather than a separate member of btrfs_fs_info, use the existing
> >>    flags field
> >
> > Looks good to me, thanks.
> I'm curious as to whether this approach is fine to get an Acked-by,

This was meant as an acked-by, the patch is now queued for 4.13, but as
it add some user-visible interface, this may need more time to see if we
haven't missed something.

> or
> if I need to figure out how to make it more leak-tolerant. I don't
> think modifying the overridden extents inflight is a problem. I'm not
> sure of a way a user would be able to create *new* chunks of data.
> Alternatively, I'd be quite happy making this applicable to metadata
> only, for file xattrs, creation, deletion, etc..

>From the interface POV, this can be set as a bitmask.  I haven't looked
if we'd be able to propagate all the changes everywhere in the code,
but sounds doable, bug I'm not sure if this level of fine-grained control
is desired.
