Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3BDC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 19:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AFA20859
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547063331;
	bh=M9RMVEuAB+TWy1RL+PimpJ2vi7HaN/DlAXkUhsCpiZE=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=JM27n3ZaBp2VPgeEGOEhK7jui94OH/8lKavE9BH2Iga9r6Rw2ZQ154sWH19sowUgU
	 ExqWNmcpWxZP0z5F1EV/UPLSJL7M59lo1Om1kMpcHz745DeOr19jvBHaXTvwaHNR4m
	 YLBgiJAkJ0/4nSBhRmLhVn77i5Vv4Qk7PKvLyemk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfAITst (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbfAITst (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Jan 2019 14:48:49 -0500
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0E7214C6
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Jan 2019 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547063328;
        bh=M9RMVEuAB+TWy1RL+PimpJ2vi7HaN/DlAXkUhsCpiZE=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=pl48DQHu3PaMgIuabj7EDb8NqGlgjmXKQGOZ0g9XDZU124Y8evr7FkYQ/gHNr8ggH
         AJBXGweUSZaeTmUhELZpAC25cPArqCwJBxOZZy/RdZ47WMdkFwyOycphjF0PE8+/WN
         AhGLAwMyEqATzZMYfWMwDmpc4HEbo0760nBvk0a8=
Received: by mail-vs1-f53.google.com with SMTP id v205so5525580vsc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2019 11:48:47 -0800 (PST)
X-Gm-Message-State: AJcUukdLouWlUVC96jnZKf5o2+0zaW4YaYm2FvkPQjG/hyIbYqrLFMba
        iQl/nneV4oYF4SZ4KvLPPyJcr/Poz0aDj0hLeKs=
X-Google-Smtp-Source: ALg8bN51EEOy4OPqFNi3lj91WDg++V/bRvOTPVmfe7wvh/AsgwuwNofaPcGidJYSaeqctnaVVseBxUPX0eB6bLnd+9o=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr2539534vsa.99.1547063327090;
 Wed, 09 Jan 2019 11:48:47 -0800 (PST)
MIME-Version: 1.0
References: <20181213211725.14832-1-fdmanana@kernel.org> <20190109182653.GN23615@twin.jikos.cz>
In-Reply-To: <20190109182653.GN23615@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 9 Jan 2019 19:48:35 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5iJ0_g8w2s-2jRMJdZLDT+pqgmtXU5dWQ6A4PjJAUpkg@mail.gmail.com>
Message-ID: <CAL3q7H5iJ0_g8w2s-2jRMJdZLDT+pqgmtXU5dWQ6A4PjJAUpkg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 9, 2019 at 6:27 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Dec 13, 2018 at 09:17:25PM +0000, fdmanana@kernel.org wrote:
> > -     if (list_empty(&fs_devices->resized_devices))
> > -             return;
> > -
> > -     mutex_lock(&fs_devices->device_list_mutex);
> >       mutex_lock(&fs_info->chunk_mutex);
> >       list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
> >                                resized_list) {
> > @@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
> >               curr->commit_total_bytes = curr->disk_total_bytes;
>
> I'm not sure about removing the device_list_mutex that's said to protect
> the commit_total_bytes (comment in struct btrfs_device).
>
> Otherwise the logic is ok, the double lock could happen as you describe.
>
> btrfs_update_commit_device_size is called from btrfs_commit_transaction,
> at the same time as commit_bytes_used. The latter is handled in a
> similar way in btrfs_update_commit_device_bytes_used, but does not take
> the device_list_mutex.
>
> commit_total_bytes is checked several times (eg. in write_dev_supers) to
> see if writing the superblock copy is still within the device range.
>
> So, without the protected change, it's theoretically possible that a
> stale value is used for the test and the superblock is either written
> though it should not, and the other way around.
>
> This would require a resize racing at the time of the check. Grow and
> shrink seem to take chunk_mutex while adjusting all the total/size
> values, but it's not actually easy to follow as sometimes there are
> helpers like btrfs_device_set_total_bytes used and sometimes it's direct
> access.
>
> That the device_list_mutex can be safely dropped probably follows from
> the simple fact that btrfs_update_commit_device_bytes_used is called
> before write_dev_supers in the same context.
>
> But this sounds too simple, given that there are locks taken and
> released and btrfs_write_and_wait_transaction called between.

Regardless of all that (and honestly I haven't double checked and
skimmed only through what you said),
there's a more important aspect I missed before: write_all_supers()
takes (and needs) the device list mutex,
therefore this change won't fix the deadlock because of that.

thanks

>
> Referencing this code:
>
> 2201         btrfs_update_commit_device_size(fs_info);
> 2202         btrfs_update_commit_device_bytes_used(cur_trans);
> 2203
> 2204         clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
> 2205         clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
> 2206
> 2207         btrfs_trans_release_chunk_metadata(trans);
> 2208
> 2209         spin_lock(&fs_info->trans_lock);
> 2210         cur_trans->state = TRANS_STATE_UNBLOCKED;
> 2211         fs_info->running_transaction = NULL;
> 2212         spin_unlock(&fs_info->trans_lock);
> 2213         mutex_unlock(&fs_info->reloc_mutex);
> 2214
> 2215         wake_up(&fs_info->transaction_wait);
> 2216
> 2217         ret = btrfs_write_and_wait_transaction(trans);
> 2218         if (ret) {
> 2219                 btrfs_handle_fs_error(fs_info, ret,
> 2220                                       "Error while writing out transaction");
> 2221                 mutex_unlock(&fs_info->tree_log_mutex);
> 2222                 goto scrub_continue;
> 2223         }
> 2224
> 2225         ret = write_all_supers(fs_info, 0);
