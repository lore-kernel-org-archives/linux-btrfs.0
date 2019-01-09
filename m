Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B21C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 18:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ADE220665
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 18:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfAIS10 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:27:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:51490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfAIS10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Jan 2019 13:27:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE07DAE3F;
        Wed,  9 Jan 2019 18:27:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E2A5CDA7E8; Wed,  9 Jan 2019 19:26:53 +0100 (CET)
Date:   Wed, 9 Jan 2019 19:26:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
Message-ID: <20190109182653.GN23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181213211725.14832-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213211725.14832-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 09:17:25PM +0000, fdmanana@kernel.org wrote:
> -	if (list_empty(&fs_devices->resized_devices))
> -		return;
> -
> -	mutex_lock(&fs_devices->device_list_mutex);
>  	mutex_lock(&fs_info->chunk_mutex);
>  	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>  				 resized_list) {
> @@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>  		curr->commit_total_bytes = curr->disk_total_bytes;

I'm not sure about removing the device_list_mutex that's said to protect
the commit_total_bytes (comment in struct btrfs_device).

Otherwise the logic is ok, the double lock could happen as you describe.

btrfs_update_commit_device_size is called from btrfs_commit_transaction,
at the same time as commit_bytes_used. The latter is handled in a
similar way in btrfs_update_commit_device_bytes_used, but does not take
the device_list_mutex.

commit_total_bytes is checked several times (eg. in write_dev_supers) to
see if writing the superblock copy is still within the device range.

So, without the protected change, it's theoretically possible that a
stale value is used for the test and the superblock is either written
though it should not, and the other way around.

This would require a resize racing at the time of the check. Grow and
shrink seem to take chunk_mutex while adjusting all the total/size
values, but it's not actually easy to follow as sometimes there are
helpers like btrfs_device_set_total_bytes used and sometimes it's direct
access.

That the device_list_mutex can be safely dropped probably follows from
the simple fact that btrfs_update_commit_device_bytes_used is called
before write_dev_supers in the same context.

But this sounds too simple, given that there are locks taken and
released and btrfs_write_and_wait_transaction called between.

Referencing this code:

2201         btrfs_update_commit_device_size(fs_info);
2202         btrfs_update_commit_device_bytes_used(cur_trans);
2203
2204         clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
2205         clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
2206
2207         btrfs_trans_release_chunk_metadata(trans);
2208
2209         spin_lock(&fs_info->trans_lock);
2210         cur_trans->state = TRANS_STATE_UNBLOCKED;
2211         fs_info->running_transaction = NULL;
2212         spin_unlock(&fs_info->trans_lock);
2213         mutex_unlock(&fs_info->reloc_mutex);
2214
2215         wake_up(&fs_info->transaction_wait);
2216
2217         ret = btrfs_write_and_wait_transaction(trans);
2218         if (ret) {
2219                 btrfs_handle_fs_error(fs_info, ret,
2220                                       "Error while writing out transaction");
2221                 mutex_unlock(&fs_info->tree_log_mutex);
2222                 goto scrub_continue;
2223         }
2224
2225         ret = write_all_supers(fs_info, 0);
