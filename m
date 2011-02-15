From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP
	bug?
Date: Tue, 15 Feb 2011 08:18:50 -0500
Message-ID: <20110215131849.GC28010@dhcp231-156.rdu.redhat.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think> <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com> <4D5A63DE.3040600@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Marti Raudsepp <marti@juffo.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	8001@debbugs.gnu.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D5A63DE.3040600@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 15, 2011 at 11:30:38AM +0000, P=E1draig Brady wrote:
> On 14/02/11 17:58, Marti Raudsepp wrote:
> > On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com>=
 wrote:
> >> Or, it could just be delalloc ;)
> >=20
> > I suspect delalloc. After creating the file, filefrag reports "1
> > extent found", but for some reason it doesn't actually print out
> > details of the extent.
>=20
> That's a bug in `filefrag -v` that I noticed independently yesterday.
> Without -v it will correctly report 0 extents.
> I've already suggested a patch to fix upstream.
>=20
> > After a "sync" call, the extent appears and "cp" starts working as =
expected:
>=20
> About that sync.
> I've noticed on ext4 loop back at least (and I suspect BTRFS is the s=
ame)
> that specifying FIEMAP_FLAG_SYNC (which cp does) is ineffective.
> I worked around this for cp tests by explicitly syncing with:
> dd if=3D/dev/null of=3Dfoo conv=3Dnotrunc,fdatasync
>

Well thats not good, thats all take care of in the generic code before =
it gets
to the fs, I'll take a look at that when I try and fix delalloc fiemap =
for
btrfs.  Thanks,

Josef=20
