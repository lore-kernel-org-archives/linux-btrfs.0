Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54591 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754671AbdEESmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 14:42:02 -0400
Date: Fri, 5 May 2017 20:41:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        BTRFS ML <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: add quota override attribute
Message-ID: <20170505184154.GM10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
 <8b6ffc4e-c5e6-3511-a8b7-2de28cc48bac@cn.fujitsu.com>
 <CAMp4zn_hU_AeEw2qNSJ7x3WKDKaWRzb=fvMxUxybRW7o=-s=LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMp4zn_hU_AeEw2qNSJ7x3WKDKaWRzb=fvMxUxybRW7o=-s=LA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 23, 2017 at 09:48:34PM -0700, Sargun Dhillon wrote:
> On Sun, Apr 23, 2017 at 8:42 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > At 04/22/2017 07:12 AM, Sargun Dhillon wrote:
> >>
> >> This patch introduces the quota override flag to btrfs_fs_info, and
> >> a change to quota limit checking code to temporarily allow for quota
> >> to be overridden for processes with cap_sys_resource.
> >>
> >> It's useful for administrative programs, such as log rotation,
> >> that may need to temporarily use more disk space in order to free up
> >> a greater amount of overall disk space without yielding more disk
> >> space to the rest of userland.
> >>
> >> Eventually, we may want to add the idea of an operator-specific
> >> quota, operator reserved space, or something else to allow for
> >> administrative override, but this is perhaps the simplest
> >> solution.
> >
> >
> > Indeed simplest method yet.
> >
> > But considering that reserved data space can be used by none privileged
> > user, I'm not sure if it's a good idea.
> >
> > For example:
> >
> > If root want to write a 64M file with new data, then it reserved 64M data
> > space.
> >
> > And another none privileged user also want to write that 64M file with
> > different data, then the user won't need to reserve data space.
> > (Although metadata space is still needed).
> >
> > Won't this cause some method to escaping the qgroup limit?
> This is more of a failure-avoidance mechanism. We run containers that
> don't have cap_sys_resource. The log rotator, on the other hand, has a
> full-set of capabilities in the root user namespace. Given that we'd
> only flip quota_override if the system gets into a state where the log
> rotator cannot run, I don't see it being particularly problematic.

So this usecase sounds valid to me. CAP_SYS_RESOURCE is documented to
allow quota overrides, no surprise here. The extra step to enable the
override per filesystem should put enough barriers against unintentional
behaviour.

> At least looking at my systems, none of my users have cap_sys_resource
> in their capabilities set, and it seems to be the closest capability
> that maps to disk quota logic. I'd hate to drop this into the bucket
> of cap_sys_admin. Are you perhaps suggesting per-uid and per-gid
> qgroups? Or being able to have a quota_override_uid value? I thought
> about adding an extended attribute, but that would require the attr to
> be set at file creation time, not necessarily when I need it for an
> escape. Another idea was to do what ext does, in adding a special
> "operator" reserved space which processes with uid == 0 &&
> cap_sys_resource can use. This would require changing the on-disk
> qgroup format.
> 
> You're right, we would (intentionally) "escape" the qgroup limit. A
> process with cap_sys_resource would be able to allocate more disk
> space temporarily If I'm understanding you correctly, I don't think
> that they would be able to rewrite the file's contents because that'd
> be considered changed extents, no?
> 
> >
> >>
> >> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> >> ---
> >>   fs/btrfs/ctree.h  | 3 +++
> >>   fs/btrfs/qgroup.c | 9 +++++++--
> >>   2 files changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> >> index c411590..01a095b 100644
> >> --- a/fs/btrfs/ctree.h
> >> +++ b/fs/btrfs/ctree.h
> >> @@ -1098,6 +1098,9 @@ struct btrfs_fs_info {
> >>         u32 nodesize;
> >>         u32 sectorsize;
> >>         u32 stripesize;
> >> +
> >> +       /* Allow tasks with cap_sys_resource to override the quota */
> >> +       bool quota_override;
> >
> >
> > Why not use existing fs_info->qgroup_flags?
> Isn't that persisted? I don't want this to surprise users across reboots.

Yes it's persisted, but we can use a bitmask for the in-memory bits
before we sync the qgroup_flags to disk.
