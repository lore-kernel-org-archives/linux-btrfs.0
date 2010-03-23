From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix how we freeze
Date: Tue, 23 Mar 2010 11:27:49 -0400
Message-ID: <20100323152749.GF2381@localhost.localdomain>
References: <20100323142818.GB2381@localhost.localdomain> <20100323145408.GD2481@laptop.oracle.com> <20100323150357.GE2381@localhost.localdomain> <20100323152518.GA2733@laptop.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Wengang Wang <wen.gang.wang@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100323152518.GA2733@laptop.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:25:18PM +0800, Wengang Wang wrote:
> On 10-03-23 11:03, Josef Bacik wrote:
> > On Tue, Mar 23, 2010 at 10:54:08PM +0800, Wengang Wang wrote:
> > > Hi,
> > > 
> > > If the only thing is returning 0 in the freeze/unfreeze member functions, why
> > > not just remove the two functions?
> > > 
> > 
> > Because if the fs doesn't provide a freeze/unfreeze function, trying to do a
> > freeze will return -EOPNOTSUPP, which is not what we want.  Thanks,
> 
> How does freeze_fs()/unfreeze_fs() get called in btrfs? I think they
> called by freeze_bdev()/unfreeze_fs() respectively. And I don't see
> -EOPNOTSUPP is returned in the later two functions.
> 

its in ioctl_fsfreeze,

        /* If filesystem doesn't support freeze feature, return. */
        if (sb->s_op->freeze_fs == NULL)
                return -EOPNOTSUPP;

Thanks,

Josef
