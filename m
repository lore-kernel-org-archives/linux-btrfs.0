From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Fri, 11 May 2012 14:34:17 -0400
Message-ID: <20120511183417.GA3503@localhost.localdomain>
References: <CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
 <20120404174300.GB2097@localhost.localdomain>
 <1333561669.12904.0.camel@falcor>
 <CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
 <20120404181622.GC2097@localhost.localdomain>
 <20120409151605.GA6482@fieldses.org>
 <20120410074801.GE11041@twin.jikos.cz>
 <CALLzPKaiYkp15DnP2m+ZdX+zVpVDWPwU7Ct+MrsetAFYXYR0ig@mail.gmail.com>
 <20120412113246.GC23876@twin.jikos.cz>
 <CALLzPKYBvUmCJp3WokkZjfryMfovsYVhrfggHfCmJ+3kb5pyQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: dave@jikos.cz, "J. Bruce Fields" <bfields@fieldses.org>,
	Josef Bacik <josef@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALLzPKYBvUmCJp3WokkZjfryMfovsYVhrfggHfCmJ+3kb5pyQA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2012 at 09:06:31AM +0300, Kasatkin, Dmitry wrote:
> On Thu, Apr 12, 2012 at 2:32 PM, David Sterba <dave@jikos.cz> wrote:
> > On Thu, Apr 12, 2012 at 02:09:08PM +0300, Kasatkin, Dmitry wrote:
> >> Where is it? Can you please point out?
> >
> > http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16662
> >
> > the relevant part:
> >
> > -- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block =
*sb,
> > =A0#ifdef CONFIG_BTRFS_FS_POSIX_ACL
> > =A0 =A0 =A0 =A0sb->s_flags |=3D MS_POSIXACL;
> > =A0#endif
> > -
> > + =A0 =A0 =A0 sb->s_flags |=3D MS_I_VERSION;
> > =A0 =A0 =A0 =A0err =3D open_ctree(sb, fs_devices, (char *)data);
> > =A0 =A0 =A0 =A0if (err) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("btrfs: open_ctree failed\n")=
;
>=20
> Hello,
>=20
> FYI:
>=20
> In fact just tried yesterday to use mount option "iversion" on 3.4-rc=
5
> and it seems to work without
>  + =A0 =A0 =A0 sb->s_flags |=3D MS_I_VERSION;

This hasn't gone in yet, it won't go in until 3.5.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
