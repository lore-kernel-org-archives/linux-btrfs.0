From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 15:38:35 -0500
Message-ID: <20100225203834.GD10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com> <20100225202358.GC10960@localhost.localdomain> <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 03:29:34PM -0500, Andrew Lutomirski wrote:
> On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrote=
:
> > On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
> >> Mounting btrfs corrupts memory and causes nasty crashes within a f=
ew
> >> seconds. =A0This seems to happen even if the mount fails (note the
> >> unrecognized mount option). =A0This is a regression from 2.6.32, a=
nd
> >> I've attached an example.
> >>
> >
> > And it only happens when you mount a btrfs fs? =A0Can you show me a=
 trace of when
> > you mount a btrfs fs with valid mount options? =A0I'd like to see i=
f we're not
> > cleaning up something properly or what. =A0Thanks,
>=20
> Seems OK.  Or maybe I just got lucky, but it's crashed every time I
> tried to mount with 'acl' before.
>=20
> I even went through a couple iterations of trying to mount with
> 'xattr' and 'user_xattr', both of which failed.
>=20

Ok it looks like we have a problem kfree'ing the wrong stuff.  we kstrd=
up the
options string, but then strsep screws with the pointer, so when we kfr=
ee() it,
we're not giving it the right pointer.  Please try this patch, and moun=
t with -o
acl and other such garbage to make sure it actually worked (acl isn't a=
 valid
mount option btw).  Let me know if it works.  Thanks,

Josef


diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..f8b4521 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -128,7 +128,7 @@ int btrfs_parse_options(struct btrfs_root *root, ch=
ar *options)
 {
 	struct btrfs_fs_info *info =3D root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num;
+	char *p, *num, *orig;
 	int intarg;
 	int ret =3D 0;
=20
@@ -143,6 +143,7 @@ int btrfs_parse_options(struct btrfs_root *root, ch=
ar *options)
 	if (!options)
 		return -ENOMEM;
=20
+	orig =3D options;
=20
 	while ((p =3D strsep(&options, ",")) !=3D NULL) {
 		int token;
@@ -280,7 +281,7 @@ int btrfs_parse_options(struct btrfs_root *root, ch=
ar *options)
 		}
 	}
 out:
-	kfree(options);
+	kfree(orig);
 	return ret;
 }
=20
