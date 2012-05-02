From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Wed, 2 May 2012 16:59:03 +0200
Message-ID: <CADy=jfUGKH+fTfhFM-TDWxiFc_eM_4qwaeTESf2NV6rKUG8pww@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz> <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
 <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com> <20120502145408.GE6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502145408.GE6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 2, 2012 at 4:54 PM, David Sterba <dave@jikos.cz> wrote:
>
> On Thu, Apr 19, 2012 at 05:42:05PM +0200, Marco L. Crociani wrote:
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.661915] Call Trace:
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.661964] =C2=A0[<ffffffffa00=
b76ac>] >
> > btrfs_ioctl_dev_info+0x15c/0x1a0 [btrfs]
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.662013] =C2=A0[<ffffffffa00=
ba9b1>] >
> > btrfs_ioctl+0x571/0x6c0 [btrfs]
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.662024] =C2=A0[<ffffffff811=
93839>] >
> > do_vfs_ioctl+0x99/0x330
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.662032] =C2=A0[<ffffffff811=
8d345>] ? =C2=A0>
> > putname+0x35/0x50
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.662040] =C2=A0[<ffffffff811=
93b71>] >
> > sys_ioctl+0xa1/0xb0
> > Apr 19 17:38:41 evo kernel: [ =C2=A0347.662049] =C2=A0[<ffffffff816=
691a9>] >
> > system_call_fastpath+0x16/0x1b
>
> Fixed by
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/16302
>
> reported earlier
> http://article.gmane.org/gmane.comp.file-systems.btrfs/16796
>
> and it's part of 3.4-rc5.
>

I was on 3.4-rc5!

--
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
