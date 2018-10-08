Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D58C67879
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 22:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F189E21476
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 22:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="KaEt0Cwx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F189E21476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbeJIFzE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 01:55:04 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:35910 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeJIFzE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 01:55:04 -0400
Received: by mail-lj1-f176.google.com with SMTP id p89-v6so19340038ljb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2018 15:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=zCMHXm/vGMaN4oivVxwm7wVGQSjAvJoLUbcVrjvPHFM=;
        b=KaEt0CwxC8bl+ALJzXBftKJcYIrvEIdHG8VOMvVoF132zlcI7B/fylRSd6GC79KlPw
         1Q/gySSlkMGeKAODYixDWkf2FHXARdNoR7emgosTSR8XKu3DGG9KjJDU05cNRii8t3O4
         NS6AXkFdRYb8pbZCFXlKwfJYr7ZY5MqunjL6LGeX2NUaiTejlFaK9fbneFC54DWq4Twx
         Bc8KAlG4+4pjb6vWEuzs+XfF02OZpicHfDq3jyPIdnf4bnsl/+SrpFHChKOXkrKmJvUJ
         G++ns2VRUVGJvq2csBpK7wvJXN7OkWOA2tjBk7kJF+yWV6VFPTZXlcmQj07PF1LcVzy+
         ZSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=zCMHXm/vGMaN4oivVxwm7wVGQSjAvJoLUbcVrjvPHFM=;
        b=o0c/OwoKPdOTXJSgepdJqPHTzCYqIyn94NSjXzgaszflkj21x4VXVuoSErU6Kmfj5m
         9IOGPjDpPkwoyYHT4Ii4/Z9bk8ygi66ue8BJ/93IA2QcpOt2wg6B3S0fkwDAjW0azpGT
         8oV32N/gCKPIlniAUZ51BFRzkkDOAoG/zgcgUkXmM3jkF2VKL6xBlC9/G1+ifua9UHJ3
         gCuRMRFLCUeUNrRZaVn33F0rYLWXMfo2l7vn+NKeYpbeHwydffBwiXMoYE3EUkwpD3hU
         vk2fOHGLy2o/s7tgzhlS45aGqSyUBsLKNHbfPpe9VekBkzIO0kN3d22XL0RsCyO0SdOy
         xWQg==
X-Gm-Message-State: ABuFfojkMgq+bZf2N17c1/TUxuzyUYPTJ4E1LgOzBlaS4zTSawS0nw5r
        u2cuFQykuh3Vet3bO2xlvBliHDR9RhADBD1k+4sV5m2lfuw=
X-Google-Smtp-Source: ACcGV63DtQo/AkxJ6NeEGq/X93mrjfMBnmiMunhOENUNfLNNFZEI4Am0gRTUXMNHFldhPtHDk4Ic5iFt75XTO3+U+es=
X-Received: by 2002:a2e:5645:: with SMTP id k66-v6mr15464745ljb.48.1539038465346;
 Mon, 08 Oct 2018 15:41:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Mon, 8 Oct 2018 15:41:04 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 8 Oct 2018 16:41:04 -0600
X-Google-Sender-Auth: DEGnalRxoWEnAbPjHJHzhnaEzB0
Message-ID: <CAJCQCtQau7DtuUUeycCkZ36qjbKuxNzsgqJ7+sJ6W0dK_NLE3w@mail.gmail.com>
Subject: qgroups not enabled, but perf stats reports btrfs_qgroup_release_data
 and btrfs_qgroup_free_delayed_ref
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[chris@flap ~]$ sudo perf stat -e 'btrfs:*' -a sleep 70
##And then I loaded a few sites in Firefox early on in those 70 seconds.

 Performance counter stats for 'system wide':

                 5      btrfs:btrfs_transaction_commit
                29      btrfs:btrfs_inode_new
                29      btrfs:btrfs_inode_request
                25      btrfs:btrfs_inode_evict
             1,602      btrfs:btrfs_get_extent
                 0      btrfs:btrfs_handle_em_exist
                 1      btrfs:btrfs_get_extent_show_fi_regular
                88      btrfs:btrfs_truncate_show_fi_regular
                19      btrfs:btrfs_get_extent_show_fi_inline
                 2      btrfs:btrfs_truncate_show_fi_inline
               189      btrfs:btrfs_ordered_extent_add
               189      btrfs:btrfs_ordered_extent_remove
                 9      btrfs:btrfs_ordered_extent_start
               592      btrfs:btrfs_ordered_extent_put
             1,207      btrfs:__extent_writepage
             1,203      btrfs:btrfs_writepage_end_io_hook
                25      btrfs:btrfs_sync_file
                 0      btrfs:btrfs_sync_fs
                 0      btrfs:btrfs_add_block_group
             1,508      btrfs:add_delayed_tree_ref
             1,498      btrfs:run_delayed_tree_ref
               379      btrfs:add_delayed_data_ref
               336      btrfs:run_delayed_data_ref
             1,887      btrfs:add_delayed_ref_head
             1,839      btrfs:run_delayed_ref_head
                 0      btrfs:btrfs_chunk_alloc
                 0      btrfs:btrfs_chunk_free
               794      btrfs:btrfs_cow_block
             6,982      btrfs:btrfs_space_reservation
                 0      btrfs:btrfs_trigger_flush
                 0      btrfs:btrfs_flush_space
               952      btrfs:btrfs_reserved_extent_alloc
                 0      btrfs:btrfs_reserved_extent_free
             1,005      btrfs:find_free_extent
             1,005      btrfs:btrfs_reserve_extent
               816      btrfs:btrfs_reserve_extent_cluster
                 1      btrfs:btrfs_find_cluster
                 0      btrfs:btrfs_failed_cluster_setup
                 1      btrfs:btrfs_setup_cluster
             5,952      btrfs:alloc_extent_state
             6,034      btrfs:free_extent_state
               374      btrfs:btrfs_work_queued
               362      btrfs:btrfs_work_sched
               362      btrfs:btrfs_all_work_done
               116      btrfs:btrfs_ordered_sched
                 0      btrfs:btrfs_workqueue_alloc
                 0      btrfs:btrfs_workqueue_destroy
                 0      btrfs:btrfs_qgroup_reserve_data
               201      btrfs:btrfs_qgroup_release_data
             1,839      btrfs:btrfs_qgroup_free_delayed_ref
                 0      btrfs:btrfs_qgroup_account_extents
                 0      btrfs:btrfs_qgroup_trace_extent
                 0      btrfs:btrfs_qgroup_account_extent
                 0      btrfs:qgroup_update_counters
                 0      btrfs:qgroup_update_reserve
                 0      btrfs:qgroup_meta_reserve
                 0      btrfs:qgroup_meta_convert
                 0      btrfs:qgroup_meta_free_all_pertrans
                 0      btrfs:btrfs_prelim_ref_merge
                 0      btrfs:btrfs_prelim_ref_insert
             2,663      btrfs:btrfs_inode_mod_outstanding_extents
                 0      btrfs:btrfs_remove_block_group
                 0      btrfs:btrfs_add_unused_block_group
                 0      btrfs:btrfs_skip_unused_block_group

      70.004723586 seconds time elapsed

[chris@flap ~]$


Seems like a lot of activity for just a few transactions, but what
really caught my eye here is the qgroup reporting for a file system
that has never had qgroups enabled. Is it expected?


Chris Murphy
