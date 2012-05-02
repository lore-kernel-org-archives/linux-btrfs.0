From: David Sterba <dave@jikos.cz>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Wed, 2 May 2012 17:27:16 +0200
Message-ID: <20120502152715.GG6740@twin.jikos.cz>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz>
 <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
 <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
 <20120502145408.GE6740@twin.jikos.cz>
 <CADy=jfUGKH+fTfhFM-TDWxiFc_eM_4qwaeTESf2NV6rKUG8pww@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfUGKH+fTfhFM-TDWxiFc_eM_4qwaeTESf2NV6rKUG8pww@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2012 at 04:59:03PM +0200, Marco L. Crociani wrote:
> > On Thu, Apr 19, 2012 at 05:42:05PM +0200, Marco L. Crociani wrote:
> > > Apr 19 17:38:41 evo kernel: [ =A0347.661964] =A0[<ffffffffa00b76a=
c>] >
> > > btrfs_ioctl_dev_info+0x15c/0x1a0 [btrfs]
[...]
> I was on 3.4-rc5!

You really saw this crash with 3.4-rc5 ? The patch should be there.
Anyway, your follow-up report was on top of 3.4-rc5, with different
error.


david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
