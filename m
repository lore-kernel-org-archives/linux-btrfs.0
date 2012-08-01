Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2HALKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 07:10:13 -0400
Received: by pbbrp8 with SMTP id rp8so936185pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 04:10:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvaGUfK0TWTacsT9i=85etzM_-aD1dC-dNVdJYws0K10tQ@mail.gmail.com>
References: <CAHf9xvaGUfK0TWTacsT9i=85etzM_-aD1dC-dNVdJYws0K10tQ@mail.gmail.com>
Date: Wed, 1 Aug 2012 13:10:12 +0200
Message-ID: <CAB9VWqC0NgYJNDkMAsfEQAmB8TkJdzQ3M=nHZCdiVHMhQAPRDQ@mail.gmail.com>
Subject: Re: Questions and notes about send/receive
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2012 at 6:32 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi Alexander,
> I relooked at my list of questions, and it seems that there are more
> general questions, and more focused questions. So here I list the
> "more focused" ones. I really appreciate if you can address them. I
> hope it's ok that I opened a separate thread for them. So here goes...
>
> iterate_dir_item(): tmp_path is not used
Removed.
>
> name_cache_insert(): if radix_tree_insert() fails, should we free the nce_head?
>
> __get_cur_name_and_parent()
> if name_cache_insert() fails, should we free the nce?
Both, nce_head and nce are now freed in name_cache_insert.
>
> __get_cur_name_and_parent()
> if is_inode_existent() is false, and we generate unique name, we don't
> set *parent_ino/*parent_gen....I guess it's ok, it just looked strange
> when it showed up in my prints.
Yepp, that's ok. We don't have a valid parent ino/gen in that case. I
added a note to the function comment.
>
> btrfs_ioctl_send()
> struct file *filp = NULL; => this is not used
>
> btrfs_ioctl_set_received_subvol()
> if we fail to commit the transaction, should we rollback the in-memory
> values that we set, like stransid/rtransid etc? or they get rolled
> back automatically somehow (I need to study the transaction
> subsystem).
Hmm not sure about that. In case of transaction abort, the FS is not
writable anymore as far as I know, so no matter which values are
in-memory, the user won't be able to use them.
>
> process_recorded_refs():
>                 /*
>                  * If the inode is still orphan, unlink the orphan. This may
>                  * happen when a previous inode did overwrite the first ref
>                  * of this inode and no new refs were added for the current
>                  * inode.
>                  */
> This comment is partially misleading, I think. It implies that the
> orphan inode will be deleted. But it may happen that it will only be
> unlinked, because another hardlink to it remains (one of my tests goes
> through this path - inode is orphanized, then orphan unlinked, but
> another hardlink exists).
This behavior is expected. We do the orphan handling only on first
refs and never check if that may generate unnecessary commands. I made
it this way because it was the easiest and most secure solution, but
it has room for optimization. A added a note about this to the
comment.
>
> btrfs-progs::read_and_process_cmd()
>                 if (strstr(path, ".bak_1.log")) {
>                         ret = 0;
>                 }
> this block is some leftover?
Hehe, yes :) I love such statements so that I can add a breakpoint to
"ret=0" :) I removed it.
>
> __get_cur_name_and_parent()
> if we decided to call get_first_ref() on the send_root (due to ino <
> sctx->send_progress), do we really need to call did_overwrite_ref()?
> Because it will just lookup the send root again. I mean if we know
> that this inode has been already handled, then it's not an orphan
> anymore, so no need for this additional check. If my understanding is
> wrong, pls give some small example?
get_first_ref does not return the current state. It returns the
permanent state. The result of did_overwrite_ref however depends on
the current send progress. There is however some room for optimization
here. In many cases, I did not think much about double tree lookups
due to the different calls, as I wanted it to work first and later
optimize it. One possible optimization for example would be to cache
the results of lookups. But only for functions which return permanent
state, e.g. get_inode_info.
>
> process_recorded_refs():
> why we need to call did_overwrite_first_ref(), and not just call
> get_cur_path()? It looks like we need this only to set the is_orphan
> flag? Because, otherwise, get_cur_path() already does the
> overwrite_first_ref logic, and will return the correct path. Is my
> understanding correct? (I ran some tests and looks correct to me).
Hmm this is probably true. It was probably required in the past to
call did_overwrite_first_ref, not sure. I would like to keep it this
way for the moment as I don't want to risk introducing new bugs.
>
> find_extent_clone():
>         /*
>          * Now collect all backrefs.
>          */
>         extent_item_pos = logical - found_key.objectid;
> Is my understanding correct that extent_item_pos will now be equal to
> btrfs_file_extent_offset(eb, fi)?
Yepp. It's probably not needed to do it this way, but I left it this
way as this part of the code is copied from Jan's initial version of
btrfs send.
>
> process_recorded_refs():
> if (ret == inode_state_did_create ||
>     ret == inode_state_no_change) {
>                         /* TODO delayed utimes */
>                         ret = send_utimes(sctx, un->val, un->aux);
> This code results in UTIMES sent twice for a parent dir of new inode:
> once because parent_dir gets changed (stamped with a transid) and
> second time because of this code. Is this fine? Also what "TODO
> delayed utimes" means?
I'm collection TODOs here:
https://btrfs.wiki.kernel.org/index.php/Btrfs_Send/Receive
One of the TODOs describes the delayed utime updates.
>
> process_recorded_refs():
> if (un->val > sctx->cur_ino)
>         continue;
> This skips some directories. Is this because we will anyhow attend to
> them later because of their ino?
Yepp. Added a comment about this.
>
> is_extent_unchanged()
>                 /*
>                  * Check if we have the same extent.
>                  */
>                 if (left_disknr + left_offset_fixed !=
>                                 right_disknr + right_offset) {
>                         ret = 0;
>                         goto out;
>                 }
> should also check: left_disknr == right_disknr for extra safety?
> Because disknr is what really defines the extent.
I changed it to:
		if (left_disknr != right_disknr ||
		    left_offset_fixed != right_offset) {
Should be more clear...
>
> is_extent_unchanged():
>                 /*
>                  * Are we at extent 8? If yes, we know the extent is changed.
>                  * This may only happen on the first iteration.
>                  */
>                 if (found_key.offset + right_len < ekey->offset) {
>                         ret = 0;
>                         goto out;
>                 }
> Should it be:
> if (found_key.offset + right_len <= ekey->offset) {
> ?
> Because in this case right extent is not overlapping also.
Hmm, true. Fixed that.
>
> struct btrfs_root_item:
> what is the difference between existing "generation" field that you
> mimic in generation_v2 and "ctransid"? (I know I need to study the
> root tree code).
Did you read the comments for btrfs_root_item and
btrfs_read_root_item? They should answer your question.
>
> Thank you,
> Alex.
Big thanks for your reviews :)
I pushed a new version of the kernel and progs side. The branches are
now "for-chris"
