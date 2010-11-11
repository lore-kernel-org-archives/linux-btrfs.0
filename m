From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Thu, 11 Nov 2010 07:52:30 -0500
Message-ID: <20101111125229.GA10179@dhcp231-156.rdu.redhat.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org> <20101111021034.GA6911@dhcp231-156.rdu.redhat.com> <AANLkTimmhCYFtq1y3Lda8O7CRTJOF4OLU-jkJ+yF965X@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimmhCYFtq1y3Lda8O7CRTJOF4OLU-jkJ+yF965X@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 10, 2010 at 09:53:23PM -0600, Mitch Harder wrote:
> On Wed, Nov 10, 2010 at 8:10 PM, Josef Bacik <josef@redhat.com> wrote=
:
> > On Wed, Nov 10, 2010 at 12:02:18PM -0600, Mitch Harder wrote:
> >> Update the mkfs.btrfs man page for the -M option to mix data and
> >> metadata chunks.
> >>
> >> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> >> ---
> >> =A0man/mkfs.btrfs.8.in | =A0 =A05 +++++
> >> =A01 files changed, 5 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
> >> index 1e14c6c..c23dddc 100644
> >> --- a/man/mkfs.btrfs.8.in
> >> +++ b/man/mkfs.btrfs.8.in
> >> @@ -9,6 +9,7 @@ mkfs.btrfs \- create an btrfs filesystem
> >> =A0[ \fB \-l\fP\fI leafsize\fP ]
> >> =A0[ \fB \-L\fP\fI label\fP ]
> >> =A0[ \fB \-m\fP\fI metadata profile\fP ]
> >> +[ \fB \-M\fP\fI mixed data+metadata\fP ]
> >> =A0[ \fB \-n\fP\fI nodesize\fP ]
> >> =A0[ \fB \-s\fP\fI sectorsize\fP ]
> >> =A0[ \fB \-h\fP ]
> >> @@ -45,6 +46,10 @@ Specify a label for the filesystem.
> >> =A0Specify how metadata must be spanned across the devices specifi=
ed. Valid
> >> =A0values are raid0, raid1, raid10 or single.
> >> =A0.TP
> >> +\fB\-M\fR, \fB\-\-mixed\fR
> >> +Mix data and metadata chunks together for more efficient space
> >> +utilization.
> >> +.TP
> >> =A0\fB\-n\fR, \fB\-\-nodesize \fIsize\fR
> >> =A0Specify the nodesize. By default the value is set to the pagesi=
ze.
> >> =A0.TP
> >> --
> >> 1.7.2.2
> >
> > Let's mention that it's for smaller filesystems since it has a sign=
ificant
> > performance impact when using mixed block groups on larger filesyst=
ems. =A0Thanks,
> >
> > Josef
> >
>=20
> OK, how about:
>=20
> Mix data and metadata chunks together for more efficient space
> utilization, especially on smaller file systems.  Incurs a performanc=
e
> penalty.

Let's say

This feature incurs a performance penalty in larger filesystems, it is
recommended for use with filesystems of 1 GiB or smaller.

Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
