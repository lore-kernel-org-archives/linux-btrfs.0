From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] btrfs: make sure all pending extent operations are
	complete
Date: Wed, 28 Jan 2009 07:05:54 -0500
Message-ID: <20090128120550.GH15050@unused.rdu.redhat.com>
References: <1233089524-17631-1-git-send-email-jbacik@redhat.com> <3d0408630901272008i2db64dc8s479a97d915e0dd48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630901272008i2db64dc8s479a97d915e0dd48@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 28, 2009 at 12:08:29PM +0800, Yan Zheng wrote:
> 2009/1/28 Josef Bacik <jbacik@redhat.com>:
> > Hello,
> >
> > Theres a slight problem with finish_current_insert, if we set all to 1 and then
> > go through and don't actually skip any of the extents on the pending list, we
> > could exit right after we've added new extents.  This is a problem because by
> > inserting the new extents we could have gotten new COW's to happen and such, so
> > we may have some pending updates to do or even more inserts to do after that.
> > So this patch will only exit if we have never skipped any of the extents in the
> > pending list, and we have no extents to insert, this will make sure that all of
> > the pending work is truly done before we return.  I've been running with this
> > patch for a few days with all of my other testing and have not seen issues.
> > Thanks,
> 
> Hi
> 
> I think this patch doesn't handle the case we only find some pending updates
> ,but neither find any pending insertion nor skip any extent on the pending list.
> In that case, num_inserts == 0, restart == 0. finish_current_insert
> exits immediately
> after update_backrefs return.  This problem is that update_backrefs may add
> new extents to the pending list.
>

Hmm crap it can can't it.  Alright I will fix that, thanks,

Josef 
