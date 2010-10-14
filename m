From: David Nicol <davidnicol@gmail.com>
Subject: PATCH added flags to cleaner-wait structure kernel-side
Date: Thu, 14 Oct 2010 11:34:54 -0500
Message-ID: <AANLkTinP7BK_x_4cep5=yZamXgmiaadBuNBe5Y4gEBj_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is once again based on
2ebc3464781ad24474abcbd2274e6254689853b5
(Dan Rosenberg July 19 2010)

The delta between this and the previous ioctl#21 kernel patch I posted =
is that
this one defines the flags field in the arguments structure, and has a
comment about the intended semantics of it, and tests for the low bit
to the effect that if the flags field is set to 1 the ioctl returns
immediately; also if it is set >1 that is an EINVAL because this
version of the kernel doesn't know that flag, and it is better to
safely full-stop instead of ignoring what might be an important flag.

Or is it a better practice to ignore unexpected fields in such things?
I think the proposed flag semantics as described in the introduction
to the latest revision of the prog-side code might make it okay to
ignore unexpected fields instead of refusing.

The scenario where it matters is, running a newer, future ioctl21
invoker that knows about some future flag, against an old (such as
current, after applying this patch) kernel that doesn't.

=46ail or ignore? Or, do I revise it again to have two flags, one to
ignore the one defined completion test, and the other to specify
ignore (0) or fail (1) semantics for unrecognized flag bits? Then I'd
have to add a command line arg for that, possibly
"--no-forward-compat" which would set the
fail-on-unrecognized-flag-bit flag.

My crystal ball might need a little adjustment, I don't know.


---------- Forwarded message ----------
Date: Thu, Oct 14, 2010 at 8:58 AM
Subject: added flags to cleaner-wait structure kernel-side
To: davidnicol@gmail.com


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..a350b75 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -895,6 +895,7 @@ struct btrfs_fs_info {
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head trans_list;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head hashers;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head dead_roots;
+ =C2=A0 =C2=A0 =C2=A0 wait_queue_head_t cleaner_notification_registrat=
ion;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head caching_block_groups;

=C2=A0 =C2=A0 =C2=A0 =C2=A0spinlock_t delayed_iput_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..6a35257 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1451,6 +1451,7 @@ static int cleaner_kthread(void *arg)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mu=
tex_trylock(&root->fs_info->cleaner_mutex)) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0btrfs_run_delayed_iputs(root);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0btrfs_clean_old_snapshots(root);
+
wake_up_all(&root->fs_info->cleaner_notification_registration);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mutex_unlock(&root->fs_info->cleaner_mutex);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

@@ -1581,6 +1582,7 @@ struct btrfs_root *open_ctree(struct super_block =
*sb,
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_RADIX_TREE(&fs_info->fs_roots_radix, GF=
P_ATOMIC);
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&fs_info->trans_list);
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&fs_info->dead_roots);
+ =C2=A0 =C2=A0 =C2=A0 init_waitqueue_head(&fs_info->cleaner_notificati=
on_registration);
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&fs_info->delayed_iputs);
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&fs_info->hashers);
=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&fs_info->delalloc_inodes);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..ffc86a8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1212,6 +1212,65 @@ static noinline int
btrfs_ioctl_ino_lookup(struct file *file,
=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
=C2=A0}

+static int btrfs_ioctl_cleaner_wait(struct btrfs_root *root, void __us=
er *arg)
+{
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_cleaner_wait_args *bicw=
a;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0long remainingjiffies;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0int err;
+
+ =C2=A0 =C2=A0 =C2=A0 bicwa =3D memdup_user(arg, sizeof(*bicwa));
+ =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(bicwa))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(bicwa=
);
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0/* the bicwa flags field is intended to ho=
ld bits
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 that will be set to 1 to disable a=
 cleanliness
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 test. =C2=A0Currently there is onl=
y one test, but
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 when there are more (or other thin=
gs, like
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reprioritizing the cleaner thread =
because something
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 is waiting on it, although that ha=
ppens already
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 because the waiting thing has yiel=
ded, so that
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 isn't really a hot to-do item) thi=
s function
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 will of course get modified to imp=
lement them. */
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bicwa->flags > 0x01) /* the highest fl=
ag we know about */
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0{
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EINVAL;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto done_with_bicwa;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bicwa->ms > 0)
+ =C2=A0 =C2=A0 =C2=A0 {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0remainingjiffies =3D wait_ev=
ent_interruptible_timeout(
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info=
->cleaner_notification_registration,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* && togethe=
r multiple FLAG OR TEST sequences
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
when there are more than one */
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ( bicwa->flag=
s & 0x01 ? 1 :
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_e=
mpty(&root->fs_info->dead_roots)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ),
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msecs_to_jiff=
ies(bicwa->ms)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (remainingjiffies > 0)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D=
 0;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (remainingjiffies < =
0 )
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D=
 -EAGAIN;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D=
 -ETIME;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+ =C2=A0 =C2=A0 =C2=A0 else
+ =C2=A0 =C2=A0 =C2=A0 {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D wait_event_interrupt=
ible(
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 root->fs_info=
->cleaner_notification_registration,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_empty(&r=
oot->fs_info->dead_roots)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0};
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0done_with_bicwa:
+ =C2=A0 =C2=A0 =C2=A0 kfree(bicwa);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
+
+}
+
+
=C2=A0static noinline int btrfs_ioctl_snap_destroy(struct file *file,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 void __user *arg)
=C2=A0{
@@ -2003,6 +2062,8 @@ long btrfs_ioctl(struct file *file, unsigned int
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return btrfs_ioc=
tl_snap_create(file, argp, 1);
=C2=A0 =C2=A0 =C2=A0 =C2=A0case BTRFS_IOC_SNAP_DESTROY:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return btrfs_ioc=
tl_snap_destroy(file, argp);
+ =C2=A0 =C2=A0 =C2=A0 case BTRFS_IOC_CLEANER_WAIT:
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return btrfs_ioctl_c=
leaner_wait(root, argp);
=C2=A0 =C2=A0 =C2=A0 =C2=A0case BTRFS_IOC_DEFAULT_SUBVOL:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return btrfs_ioc=
tl_default_subvol(file, argp);
=C2=A0 =C2=A0 =C2=A0 =C2=A0case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..18ff143 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -138,6 +138,11 @@ struct btrfs_ioctl_space_args {
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_space_info spaces[0];
=C2=A0};

+struct btrfs_ioctl_cleaner_wait_args{
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long ms;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
+};
+
=C2=A0#define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_ioctl_vol_ar=
gs)
=C2=A0#define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -178,4 +183,6 @@ struct btrfs_ioctl_space_args {
=C2=A0#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
=C2=A0#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_=
space_args)
+#define BTRFS_IOC_CLEANER_WAIT _IOW(BTRFS_IOCTL_MAGIC, 21, \
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_ioctl_cl=
eaner_wait_args)
=C2=A0#endif



--=20
l'=C3=A9galit=C3=A9 des droits pour les ambidextres
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
