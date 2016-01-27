Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbcA0Mjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 07:39:42 -0500
Date: Wed, 27 Jan 2016 13:39:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: sysfs: check initialization state before updating
 features
Message-ID: <20160127123930.GL8567@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453889679-25588-1-git-send-email-dsterba@suse.com>
 <CAHji150m=sgHJ4SLB7YYD6DzkrSgcBfheqoDr=uwJm4LDuwtwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAHji150m=sgHJ4SLB7YYD6DzkrSgcBfheqoDr=uwJm4LDuwtwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2016 at 12:20:48PM +0100, Holger Hoffstätte wrote:
> On Wed, Jan 27, 2016 at 11:14 AM, David Sterba <dsterba@suse.com> wrote:
> > If the mount phase is not finished, we can't update the sysfs files.
> >
> > Reported-by: Chris Mason <clm@fb.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/sysfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 6986886243bf..1ae146a8093c 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -804,6 +804,9 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> >         fs_devs = fs_info->fs_devices;
> >         fsid_kobj = &fs_devs->fsid_kobj;
> >
> > +       if (!fsid_kobj.state_initialized)
> > +               return;
> > +
> 
> uhm..
> 
> fs/btrfs/sysfs.c: In function 'btrfs_sysfs_feature_update':
> fs/btrfs/sysfs.c:807:16: error: request for member 'state_initialized'
> in something not a structure or union
>   if (!fsid_kobj.state_initialized)
>                 ^
> 
> I think this should be fsid_kobj->state_initialized, no?

Of course. What I've tested was

       if (!fs_devs->fsid_kobj.state_initialized)

and removed the "fs_devs->" but did not recompile. 
