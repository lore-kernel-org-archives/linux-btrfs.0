From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, fixed] Prevent oopsing in posix_acl_valid()
Date: Tue, 10 May 2011 07:21:52 -0400
Message-ID: <1305026462-sup-8671@shiny>
References: <1304477648-14952-1-git-send-email-daniel.blueman@gmail.com> <4DC16572.8020005@redhat.com> <BANLkTinf-DQmmG==JNndPtLRCaAB3zV1XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>, Christian Brunner <chb@muc.de>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTinf-DQmmG==JNndPtLRCaAB3zV1XA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Daniel J Blueman's message of 2011-05-10 01:42:45 -0400:
> Hi Chris,
>=20
> On 4 May 2011 22:40, Josef Bacik <josef@redhat.com> wrote:
> > On 05/03/2011 10:54 PM, Daniel J Blueman wrote:
> >>
> >> If posix_acl_from_xattr() returns an error code, a negative addres=
s is
> >> dereferenced causing an oops; fix by checking for an error code fi=
rst.
> >>
> >> Typo fixed; too much late-night coding.
> >>
> >> Signed-off-by: Daniel J Blueman<daniel.blueman@gmail.com>
> >> ---
> >> =C2=A0fs/btrfs/acl.c | =C2=A0 =C2=A05 +++--
> >> =C2=A01 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> >> index 5d505aa..44ea5b9 100644
> >> --- a/fs/btrfs/acl.c
> >> +++ b/fs/btrfs/acl.c
> >> @@ -178,12 +178,13 @@ static int btrfs_xattr_acl_set(struct dentry
> >> *dentry, const char *name,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (value) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0acl =3D pos=
ix_acl_from_xattr(value, size);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(acl)=
)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return PTR_ERR(acl);
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (acl) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0ret =3D posix_acl_valid(acl);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (ret)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (IS_E=
RR(acl)) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return PTR_ERR(acl);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >>
> >
> > Actually pulled this down and compiled it this time to make sure it=
 worked.
> > =C2=A0You can add
> >
> > Reviewed-by: Josef Bacik <josef@redhat.com>
>=20
> Will this fix go upstream for the final 2.6.39, now that the last -rc
> is already out? I hit it in two independent cases when rebooting afte=
r
> other kernel crashes.

Yes, I have one other patch to from Li Zefan that I will send along.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
