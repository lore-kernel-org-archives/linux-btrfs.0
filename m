From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH V3] Btrfs: fix subvolume mount by name problem when
 default mount subvolume is set
Date: Wed, 6 Apr 2011 16:42:45 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB68A76FFBF8C@shsmsx502.ccr.corp.intel.com>
References: <1302075231-13105-1-git-send-email-xin.zhong@intel.com>
 <4D9C269E.6030308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9C269E.6030308@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Andreas Philipp [mailto:philipp.andreas@gmail.com]
> Sent: Wednesday, April 06, 2011 4:39 PM
> To: Zhong, Xin
> Cc: linux-btrfs@vger.kernel.org; Andreas Philipp
> Subject: Re: [PATCH V3] Btrfs: fix subvolume mount by name problem when
> default mount subvolume is set
> 
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Just a (probably) short question. This means, one now can mount any
> subvolume which lies directly in another subvolume by name, as long as
> one passes the correct subvolrootid=X mount option?

Yes. That's exactly what this patch does. Thanks!

> 
> Thanks,
> Andreas Philipp
> 
> On 06.04.2011 09:33, Zhong, Xin wrote:
> > We create two subvolumes (meego_root and meego_home) in
> > btrfs root directory. And set meego_root as default mount
> > subvolume. After we remount btrfs, meego_root is mounted
> > to top directory by default. Then when we try to mount
> > meego_home (subvol=meego_home) to a subdirectory, it failed.
> > The problem is when default mount subvolume is set to
> > meego_root, we search meego_home in meego_root but can not find
> > it. So the solution is to add a new mount option (subvolrootid)
> > to specify subvol id of root and search subvol name in it. For
> > our case, now we can use "-o subvolrootid=0,subvol=meego_home)
> > to mount meego_home.
> >
> > Detail information can be found in meego bugzilla:
> > https://bugs.meego.com/show_bug.cgi?id=15055
> >
> > Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> > ---
> > fs/btrfs/super.c | 42 +++++++++++++++++++++++++++++++++---------
> > 1 files changed, 33 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index db0a827..b85fe78 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -156,7 +156,7 @@ enum {
> > Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
> > Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
> > Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
> > - Opt_enospc_debug, Opt_err,
> > + Opt_enospc_debug, Opt_subvolrootid, Opt_err,
> > };
> >
> > static match_table_t tokens = {
> > @@ -186,6 +186,7 @@ static match_table_t tokens = {
> > {Opt_clear_cache, "clear_cache"},
> > {Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
> > {Opt_enospc_debug, "enospc_debug"},
> > + {Opt_subvolrootid, "subvolrootid=%d"},
> > {Opt_err, NULL},
> > };
> >
> > @@ -229,6 +230,7 @@ int btrfs_parse_options(struct btrfs_root *root,
> char *options)
> > break;
> > case Opt_subvol:
> > case Opt_subvolid:
> > + case Opt_subvolrootid:
> > case Opt_device:
> > /*
> > * These are parsed by btrfs_parse_early_options
> > @@ -385,7 +387,7 @@ out:
> > */
> > static int btrfs_parse_early_options(const char *options, fmode_t
> flags,
> > void *holder, char **subvol_name, u64 *subvol_objectid,
> > - struct btrfs_fs_devices **fs_devices)
> > + u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
> > {
> > substring_t args[MAX_OPT_ARGS];
> > char *opts, *orig, *p;
> > @@ -426,6 +428,18 @@ static int btrfs_parse_early_options(const char
> *options, fmode_t flags,
> > *subvol_objectid = intarg;
> > }
> > break;
> > + case Opt_subvolrootid:
> > + intarg = 0;
> > + error = match_int(&args[0], &intarg);
> > + if (!error) {
> > + /* we want the original fs_tree */
> > + if (!intarg)
> > + *subvol_rootid =
> > + BTRFS_FS_TREE_OBJECTID;
> > + else
> > + *subvol_rootid = intarg;
> > + }
> > + break;
> > case Opt_device:
> > error = btrfs_scan_one_device(match_strdup(&args[0]),
> > flags, holder, fs_devices);
> > @@ -715,6 +729,7 @@ static int btrfs_get_sb(struct file_system_type
> *fs_type, int flags,
> > fmode_t mode = FMODE_READ;
> > char *subvol_name = NULL;
> > u64 subvol_objectid = 0;
> > + u64 subvol_rootid = 0;
> > int error = 0;
> >
> > if (!(flags & MS_RDONLY))
> > @@ -722,7 +737,7 @@ static int btrfs_get_sb(struct file_system_type
> *fs_type, int flags,
> >
> > error = btrfs_parse_early_options(data, mode, fs_type,
> > &subvol_name, &subvol_objectid,
> > - &fs_devices);
> > + &subvol_rootid, &fs_devices);
> > if (error)
> > return error;
> >
> > @@ -786,15 +801,17 @@ static int btrfs_get_sb(struct file_system_type
> *fs_type, int flags,
> > s->s_flags |= MS_ACTIVE;
> > }
> >
> > - root = get_default_root(s, subvol_objectid);
> > - if (IS_ERR(root)) {
> > - error = PTR_ERR(root);
> > - deactivate_locked_super(s);
> > - goto error_free_subvol_name;
> > - }
> > /* if they gave us a subvolume name bind mount into that */
> > if (strcmp(subvol_name, ".")) {
> > struct dentry *new_root;
> > +
> > + root = get_default_root(s, subvol_rootid);
> > + if (IS_ERR(root)) {
> > + error = PTR_ERR(root);
> > + deactivate_locked_super(s);
> > + goto error_free_subvol_name;
> > + }
> > +
> > mutex_lock(&root->d_inode->i_mutex);
> > new_root = lookup_one_len(subvol_name, root,
> > strlen(subvol_name));
> > @@ -815,6 +832,13 @@ static int btrfs_get_sb(struct file_system_type
> *fs_type, int flags,
> > }
> > dput(root);
> > root = new_root;
> > + } else {
> > + root = get_default_root(s, subvol_objectid);
> > + if (IS_ERR(root)) {
> > + error = PTR_ERR(root);
> > + deactivate_locked_super(s);
> > + goto error_free_subvol_name;
> > + }
> > }
> >
> > mnt->mnt_sb = s;
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJNnCaeAAoJEJIcBJ3+Xkgi8AYP/2kZW9AkQOJoCFQiDipTF5ck
> yeXqKAqaMnmry0XY3I3ideZKpFp5C1U6QqoA/uy/ieHDx1OPix+wciLuqo/uxbKj
> LG3bKJTEcZ5swdjY6oHsTp9iQFXn5tNHTb0Sayha6QaJgkQ/FU4AV5jPmXdN5DvE
> xGuaY08rvshE2Bm6nqG5KpRIeuaPoGRd7qFvorhzzMDZ1bEZ8OcbDy4q4SgTR3ji
> mgDARmtnh38IASIb5/6CXLVsCgMf2t4lKlXA6pwFXruKyOfxNBRUzPjyTNuuErli
> 6b4/eHPn4lmhNelvScnCs6zHxdRQQAheX4r7uRQ+eSQmR+6DzZg9p+1TJcfr3/mn
> 18LRhGaCgFs5mXVwA+5bDQghcTZpFAePRa5hDxUvw2XKBq2/fp8FEjyBtFbAYumW
> /i4/X0FWOABBrQuD7Pg+gEDXL4nFokJFGlxamqDgDlsMZaPL/RHD+eC3FAYO1dYU
> EJSPRAYQCery1jRpmFey5X6foh6QWj0QF/LL7jBx5/bMevsmbQkESntSgH2Tkhj8
> eAeu2wvv8p1ctuMeTUDDLxjrot6ADLM+fYiNZ1RdPD6CDHdjo4GUL4wZ85P1ZyqS
> J33SgJFLjP74TZS96SCtOsugJV2N+5zmfzxkdsocT8uO4nRqSPF0dyxnXKdrbMN3
> VpQaQIhLPLKJ7tJWAFhV
> =jIhF
> -----END PGP SIGNATURE-----

