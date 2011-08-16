From: Dan Merillat <dan.merillat@gmail.com>
Subject: processes stuck in llseek
Date: Mon, 15 Aug 2011 23:59:50 -0400
Message-ID: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a series of hung_task notifications in dmesg, so I went
poking at it.   Process is 'dropbox', and it's stuck trying to llseek
it's library.zip file.

strace of dropbox:
...
stat("/home/x/.dropbox-dist/library.zip", {st_mode=S_IFREG|0755,
st_size=11575179, ...}) = 0
open("/home/x/.dropbox-dist/library.zip", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=11575179, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fa766ea8000
fstat(3, {st_mode=S_IFREG|0755, st_size=11575179, ...}) = 0
lseek(3, 11571200, SEEK_SET

SEEK_SET is less than st_size

strace of dd if=library.zip of=/dev/null bs=1 seek=11571200:

open("library.zip", O_RDONLY)           = 3
dup2(3, 0)                              = 0
close(3)                                = 0
lseek(0, 0, SEEK_CUR

[72960.716080] INFO: task dropbox:1348 blocked for more than 120 seconds.
[72960.716084] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[72960.716087] dropbox         D ffff8800762d8a78     0  1348      1 0x00000004
[72960.716092]  ffff880069cede18 0000000000000086 0000000000096000
0000000000000000
[72960.716097]  ffff880069cec000 00000000000119c0 ffff8800762d8700
00000000000119c0
[72960.716101]  ffff880069cedfd8 0000000000004000 ffff880069cedfd8
00000000000119c0
[72960.716106] Call Trace:
[72960.716113]  [<ffffffff81331f9e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[72960.716119]  [<ffffffff8155710a>] ? retint_restore_args+0xe/0xe
[72960.716124]  [<ffffffff810e8ef1>] ? noop_llseek+0xa/0xa
[72960.716129]  [<ffffffff810340ff>] ? mutex_spin_on_owner+0x1c/0x45
[72960.716133]  [<ffffffff81555be0>] __mutex_lock_slowpath+0xd2/0x116
[72960.716137]  [<ffffffff81559edd>] ? do_page_fault+0x374/0x3e6
[72960.716140]  [<ffffffff81555a87>] mutex_lock+0x16/0x27
[72960.716146]  [<ffffffff812c8ad7>] btrfs_file_llseek+0x38/0x297
[72960.716150]  [<ffffffff81331fda>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[72960.716153]  [<ffffffff810e8f2c>] vfs_llseek+0x2e/0x30
[72960.716155]  [<ffffffff810e9311>] sys_lseek+0x3e/0x5d
[72960.716159]  [<ffffffff8155d4fb>] system_call_fastpath+0x16/0x1b

Oddly enough, it's just llseek.  I can copy/read the file sequentially
just fine, but llseek fails on a copy as well.   Once I get physically
to the system I'll recompile to an unmodified kernel and try again.
Other files of the same approximate age llseek correctly.

Kernel is 3.1-rc1  with the fglrx module from AMD and the following
patch:  (I was playing with cross-subvolume reflinking, but not on
this file)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cf0133..a13b5e2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2182,7 +2182,7 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
 		goto out_fput;

 	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
+	if (src->i_sb != inode->i_sb)
 		goto out_fput;

 	ret = -ENOMEM;
@@ -2246,13 +2246,13 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;

 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(root, path);
+			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
@@ -2313,7 +2313,7 @@ static noinline long btrfs_ioctl_clone(struct
file *file, unsigned long srcfd,
 			else
 				new_key.offset = destoff;

-			trans = btrfs_start_transaction(root, 1);
+			trans = btrfs_start_transaction(root, 3);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
