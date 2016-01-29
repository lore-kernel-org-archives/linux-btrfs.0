Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44603 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176AbcA2Odk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 09:33:40 -0500
Date: Fri, 29 Jan 2016 09:33:31 -0500
From: Chris Mason <clm@fb.com>
To: Filipe Manana <fdmanana@gmail.com>
CC: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: sysfs: introduce helper for syncing bits with
 sysfs files
Message-ID: <20160129143331.nwxyq5ar3j2xxw53@floor.thefacebook.com>
References: <cover.1453400624.git.dsterba@suse.com>
 <444e75169872f668eb890f19ec1f32dfc632e704.1453400624.git.dsterba@suse.com>
 <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:55:31PM +0000, Filipe Manana wrote:
> On Thu, Jan 21, 2016 at 6:32 PM, David Sterba <dsterba@suse.com> wrote:
> > The files under /sys/fs/UUID/features get out of sync with the actual
> > incompat bits set for the filesystem if they change after mount. We're
> > going to sync them and need a helper to do that.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/sysfs.c | 30 ++++++++++++++++++++++++++++++
> >  fs/btrfs/sysfs.h |  3 +++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 906f7ed6fc80..6986886243bf 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -782,6 +782,36 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
> >         return error;
> >  }
> >
> > +
> > +/*
> > + * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
> > + * values in superblock. Call after any changes to incompat/compat_ro flags
> > + */
> > +void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> > +               u64 bit, enum btrfs_feature_set set)
> > +{
> > +       struct btrfs_fs_devices *fs_devs;
> > +       struct kobject *fsid_kobj;
> > +       u64 features;
> > +       int ret;
> > +
> > +       if (!fs_info)
> > +               return;
> > +
> > +       features = get_features(fs_info, set);
> > +       ASSERT(bit & supported_feature_masks[set]);
> > +
> > +       fs_devs = fs_info->fs_devices;
> > +       fsid_kobj = &fs_devs->fsid_kobj;
> > +
> > +       /*
> > +        * FIXME: this is too heavy to update just one value, ideally we'd like
> > +        * to use sysfs_update_group but some refactoring is needed first.
> > +        */
> > +       sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
> > +       ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> 
> 
> Did you try to run all xfstests with this?
> 
> I'm getting very often lots of warnings in btrfs tests 060 to 074:

I did, but I have the compression remount tests ratelimited a bit
because of bugs in mount on my test box.

I might wait on the whole pull until before rc3, so we can sort this out
properly.

-chris
