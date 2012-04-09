From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Mon, 9 Apr 2012 11:16:05 -0400
Message-ID: <20120409151605.GA6482@fieldses.org>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
 <1332771031-3337-2-git-send-email-josef@redhat.com>
 <CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
 <20120404174300.GB2097@localhost.localdomain>
 <1333561669.12904.0.camel@falcor>
 <CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
 <20120404181622.GC2097@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120404181622.GC2097@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2012 at 02:16:22PM -0400, Josef Bacik wrote:
> On Wed, Apr 04, 2012 at 09:12:57PM +0300, Kasatkin, Dmitry wrote:
> > On Wed, Apr 4, 2012 at 8:47 PM, Mimi Zohar <zohar@linux.vnet.ibm.co=
m> wrote:
> > > On Wed, 2012-04-04 at 13:43 -0400, Josef Bacik wrote:
> > >> On Wed, Apr 04, 2012 at 08:24:19PM +0300, Kasatkin, Dmitry wrote=
:
> > >> > Hello,
> > >> >
> > >> > Mimi and I working on IMA/EVM (security/integrity) and it uses
> > >> > i_version for checking if file content has been changed.
> > >> > extX file systems support i_version updates with mounting file=
 system
> > >> > with "iversion" option or via kernel command line parameter
> > >> > "i_version"
> > >> >
> > >> > It seems iversion option is not recognized when mounting btrfs=
=2E
> > >> > I see this patchset deals with i_version update as well..
> > >> > Can you please give an advice how to use i_version with btrfs?
> > >> >
> > >>
> > >> Oh good somebody uses this? =C2=A0We actually have a ->sequence =
thing we use for
> > >> this, the grand idea was to make it smarter about telling nfs wh=
en something
> > >> changed, but if you guys use i_version we could probably get rid=
 of our in-core
> > >> sequence and use the normal inodes i_version and then just store=
 it in our
> > >> sequence field on disk. =C2=A0I'll do it without a mount option =
tho so it just works,
> > >> does that sound good to you? =C2=A0Thanks,
> >=20
> > Hello,
> >=20
> > Thank you for the answer...
> > But can you a bit clarify...
> >=20
> > Looking to file_update_time() I see that it does:
> >=20
> > 	if (IS_I_VERSION(inode))
> > 		sync_it |=3D S_VERSION;
> >=20
> > Basically it should be (inode->i_sb->s_flags & MS_I_VERSION)
> >=20
> > use of i_version is controlled by iversion mount flag.
> > for ext4 I see in parse_options():
> >=20
> > 		case Opt_i_version:
> > 			set_opt(sb, I_VERSION);
> > 			sb->s_flags |=3D MS_I_VERSION;
> > 			break;
> >=20
> >=20
> > But who sets MS_I_VERSION in s_flags on btrfs?
> >=20
>=20
> Nobody yet, I'm going to send a patch shortly that will support this.=
  Thanks,

Great.  It would also be far preferable if it was just always on (at
least by default) rather than requiring a mount option.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
