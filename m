Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48601 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2GaQcG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 12:32:06 -0400
Received: by qcro28 with SMTP id o28so3855634qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 09:32:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 19:32:05 +0300
Message-ID: <CAHf9xvaGUfK0TWTacsT9i=85etzM_-aD1dC-dNVdJYws0K10tQ@mail.gmail.com>
Subject: Questions and notes about send/receive
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,
I relooked at my list of questions, and it seems that there are more
general questions, and more focused questions. So here I list the
"more focused" ones. I really appreciate if you can address them. I
hope it's ok that I opened a separate thread for them. So here goes...

iterate_dir_item(): tmp_path is not used

name_cache_insert(): if radix_tree_insert() fails, should we free the nce_head?

__get_cur_name_and_parent()
if name_cache_insert() fails, should we free the nce?

__get_cur_name_and_parent()
if is_inode_existent() is false, and we generate unique name, we don't
set *parent_ino/*parent_gen....I guess it's ok, it just looked strange
when it showed up in my prints.

btrfs_ioctl_send()
struct file *filp = NULL; => this is not used

btrfs_ioctl_set_received_subvol()
if we fail to commit the transaction, should we rollback the in-memory
values that we set, like stransid/rtransid etc? or they get rolled
back automatically somehow (I need to study the transaction
subsystem).

process_recorded_refs():
		/*
		 * If the inode is still orphan, unlink the orphan. This may
		 * happen when a previous inode did overwrite the first ref
		 * of this inode and no new refs were added for the current
		 * inode.
		 */
This comment is partially misleading, I think. It implies that the
orphan inode will be deleted. But it may happen that it will only be
unlinked, because another hardlink to it remains (one of my tests goes
through this path - inode is orphanized, then orphan unlinked, but
another hardlink exists).

btrfs-progs::read_and_process_cmd()
		if (strstr(path, ".bak_1.log")) {
			ret = 0;
		}
this block is some leftover?

__get_cur_name_and_parent()
if we decided to call get_first_ref() on the send_root (due to ino <
sctx->send_progress), do we really need to call did_overwrite_ref()?
Because it will just lookup the send root again. I mean if we know
that this inode has been already handled, then it's not an orphan
anymore, so no need for this additional check. If my understanding is
wrong, pls give some small example?

process_recorded_refs():
why we need to call did_overwrite_first_ref(), and not just call
get_cur_path()? It looks like we need this only to set the is_orphan
flag? Because, otherwise, get_cur_path() already does the
overwrite_first_ref logic, and will return the correct path. Is my
understanding correct? (I ran some tests and looks correct to me).

find_extent_clone():
	/*
	 * Now collect all backrefs.
	 */
	extent_item_pos = logical - found_key.objectid;
Is my understanding correct that extent_item_pos will now be equal to
btrfs_file_extent_offset(eb, fi)?

process_recorded_refs():
if (ret == inode_state_did_create ||
    ret == inode_state_no_change) {
			/* TODO delayed utimes */
			ret = send_utimes(sctx, un->val, un->aux);
This code results in UTIMES sent twice for a parent dir of new inode:
once because parent_dir gets changed (stamped with a transid) and
second time because of this code. Is this fine? Also what "TODO
delayed utimes" means?

process_recorded_refs():
if (un->val > sctx->cur_ino)
	continue;
This skips some directories. Is this because we will anyhow attend to
them later because of their ino?

is_extent_unchanged()
		/*
		 * Check if we have the same extent.
		 */
		if (left_disknr + left_offset_fixed !=
				right_disknr + right_offset) {
			ret = 0;
			goto out;
		}
should also check: left_disknr == right_disknr for extra safety?
Because disknr is what really defines the extent.

is_extent_unchanged():
		/*
		 * Are we at extent 8? If yes, we know the extent is changed.
		 * This may only happen on the first iteration.
		 */
		if (found_key.offset + right_len < ekey->offset) {
			ret = 0;
			goto out;
		}
Should it be:
if (found_key.offset + right_len <= ekey->offset) {
?
Because in this case right extent is not overlapping also.

struct btrfs_root_item:
what is the difference between existing "generation" field that you
mimic in generation_v2 and "ctransid"? (I know I need to study the
root tree code).

Thank you,
Alex.
