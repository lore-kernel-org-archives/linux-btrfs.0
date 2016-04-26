Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbcDZVoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 17:44:16 -0400
Date: Tue, 26 Apr 2016 23:44:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: sysfs: protect reading label by lock
Message-ID: <20160426214403.GG29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1461681045.git.dsterba@suse.com>
 <f7692e58a8e6a7bd28160adfc664e9e8ccfa6fcc.1461681045.git.dsterba@suse.com>
 <CAL3q7H7myUQ6FbkwTcr1Qb0oqyCt2iV=My2k_rf2P606oTWoNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7myUQ6FbkwTcr1Qb0oqyCt2iV=My2k_rf2P606oTWoNQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 04:52:09PM +0100, Filipe Manana wrote:
> On Tue, Apr 26, 2016 at 3:32 PM, David Sterba <dsterba@suse.com> wrote:
> > If the label setting ioctl races with sysfs label handler, we could get
> > mixed result in the output, part old part new. We should either get the
> > old or new label. The chances to hit this race are low.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/sysfs.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 3d14618ce54b..7b0da1dcb6df 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -367,7 +367,12 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
> >  {
> >         struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> >         char *label = fs_info->super_copy->label;
> > -       return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
> > +
> > +       spin_lock(&fs_info->super_lock);
> > +       snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
> > +       spin_unlock(&fs_info->super_lock);
> > +
> > +       return buf;
> 
> We should return a ssize_t value, not a char *. I.e. return what
> snprintf returns. This should make gcc emit a warning.

Indeed the warning was there and I overlooked it, last minute patches
before leaving. Thanks for catching it.
