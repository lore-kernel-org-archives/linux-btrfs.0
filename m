Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2HAMJw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:09:52 -0400
MIME-Version: 1.0
Date: Wed, 1 Aug 2012 14:09:52 +0200
Message-ID: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
Subject: btrfs send/receive review by vfs folks
From: Alexander Block <ablock84@googlemail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm sending this to fsdevel as we're using vfs functions to open
inodes and read/write from them in btrfs send/receive and a review by
vfs folks would probably be a good thing here. I extracted the vfs
related functions from the current version and copied them into this
mail below.

write_buf:
Used to write the stream to a user space supplied pipe. Please note
the ERESTARTSYS comment there, I need some help here as I don't know
how to handle that correctly. If I ignore the return value, it loops
forever. If I bail out to user space, it reenters the ioctl and starts
from the beginning (which is really bad). I have two possible
solutions in my mind.
1. Store some kind of state in the ioctl arguments so that we can
continue where we stopped when the ioctl reenters. This would however
complicate the code a lot.
2. Spawn a thread when the ioctl is called and leave the ioctl
immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
if they happen from a non syscall thread.

Comments/Help would be really appreciated here.

open_cur_inode_file:
Opens the currently processed inode for reading. Bails out in case it
is already open. This function is called multiple times per inode,
it's called once per extent.

close_cur_inode_file:
Closes the filp that was opened by open_cur_inode_file. It is called
when the current inode is done processing.

send_write:
Used for changed extents that needs to be sent to user space. The len
is limited to 48k and thus called multiple times with different
offsets per extent. It first uses vfs_read to read from the file and
then TLV_PUT_XXX to write the data to the user space pipe.
The TLV_PUT_XXX macros perform calls to write_buf. In case something
fails there, these macros do a goto to tlv_put_failure.
The same ERESTARTSYS logic as in write_buf will probably be needed
here for the vfs_read calls.

[...]
static int write_buf(struct send_ctx *sctx, const void *buf, u32 len)
{
	int ret;
	mm_segment_t old_fs;
	u32 pos = 0;

	old_fs = get_fs();
	set_fs(KERNEL_DS);

	while (pos < len) {
		ret = vfs_write(sctx->send_filp, (char *)buf + pos, len - pos,
				&sctx->send_off);
		/* TODO handle that correctly */
		/*if (ret == -ERESTARTSYS) {
			continue;
		}*/
		if (ret < 0)
			goto out;
		if (ret == 0) {
			ret = -EIO;
			goto out;
		}
		pos += ret;
	}

	ret = 0;

out:
	set_fs(old_fs);
	return ret;
}
[...]
/*
 * Called for regular files when sending extents data. Opens a struct file
 * to read from the file.
 */
static int open_cur_inode_file(struct send_ctx *sctx)
{
	int ret = 0;
	struct btrfs_key key;
	struct path path;
	struct inode *inode;
	struct dentry *dentry;
	struct file *filp;
	int new = 0;

	if (sctx->cur_inode_filp)
		goto out;

	key.objectid = sctx->cur_ino;
	key.type = BTRFS_INODE_ITEM_KEY;
	key.offset = 0;

	inode = btrfs_iget(sctx->send_root->fs_info->sb, &key, sctx->send_root,
			&new);
	if (IS_ERR(inode)) {
		ret = PTR_ERR(inode);
		goto out;
	}

	dentry = d_obtain_alias(inode);
	inode = NULL;
	if (IS_ERR(dentry)) {
		ret = PTR_ERR(dentry);
		goto out;
	}

	path.mnt = sctx->mnt;
	path.dentry = dentry;
	filp = dentry_open(&path, O_RDONLY | O_LARGEFILE, current_cred());
	dput(dentry);
	dentry = NULL;
	if (IS_ERR(filp)) {
		ret = PTR_ERR(filp);
		goto out;
	}
	sctx->cur_inode_filp = filp;

out:
	/*
	 * no xxxput required here as every vfs op
	 * does it by itself on failure
	 */
	return ret;
}

/*
 * Closes the struct file that was created in open_cur_inode_file
 */
static int close_cur_inode_file(struct send_ctx *sctx)
{
	int ret = 0;

	if (!sctx->cur_inode_filp)
		goto out;

	ret = filp_close(sctx->cur_inode_filp, NULL);
	sctx->cur_inode_filp = NULL;

out:
	return ret;
}
[...]
/*
 * Read some bytes from the current inode/file and send a write command to
 * user space.
 */
static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
{
	int ret = 0;
	struct fs_path *p;
	loff_t pos = offset;
	int num_read = 0;
	mm_segment_t old_fs;

	p = fs_path_alloc(sctx);
	if (!p)
		return -ENOMEM;

	/*
	 * vfs normally only accepts user space buffers for security reasons.
	 * we only read from the file and also only provide the read_buf buffer
	 * to vfs. As this buffer does not come from a user space call, it's
	 * ok to temporary allow kernel space buffers.
	 */
	old_fs = get_fs();
	set_fs(KERNEL_DS);

verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);

	ret = open_cur_inode_file(sctx);
	if (ret < 0)
		goto out;

	ret = vfs_read(sctx->cur_inode_filp, sctx->read_buf, len, &pos);
	if (ret < 0)
		goto out;
	num_read = ret;
	if (!num_read)
		goto out;

	ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
	if (ret < 0)
		goto out;

	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
	if (ret < 0)
		goto out;

	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
	TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, num_read);

	ret = send_cmd(sctx);

tlv_put_failure:
out:
	fs_path_free(sctx, p);
	set_fs(old_fs);
	if (ret < 0)
		return ret;
	return num_read;
}
[...]
