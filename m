Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A693C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7052075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfDOO1z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:27:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:55690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbfDOO1z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 10:27:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 922CEAD64
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 14:27:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 304A9DA9C7; Mon, 15 Apr 2019 16:28:58 +0200 (CEST)
Date:   Mon, 15 Apr 2019 16:28:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] btrfs: trace: Trace events for btrfs tree locking
Message-ID: <20190415142854.GH3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190415131525.20274-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415131525.20274-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 09:15:23PM +0800, Qu Wenruo wrote:
> This branch can be fetched from github:
> https://github.com/adam900710/linux/tree/trace_locking
> Which is based on v5.1-rc4 tag.
> 
> This patchset will introduce the following trace events for corresponding
> functions:
>   btrfs_tree_lock			(sleepable)
>   btrfs_tree_unlock
>   btrfs_tree_read_lock			(sleepable)
>   btrfs_tree_read_unlock
>   btrfs_tree_read_unlock_blocking
>   btrfs_set_lock_blocking_read
>   btrfs_set_lock_blocking_write
>   btrfs_clear_lock_blocking_read
>   btrfs_clear_lock_blocking_write
>   btrfs_try_tree_read_lock
>   btrfs_try_tree_write_lock
>   btrfs_tree_read_lock_atomic
> 
> The two sleepable ones will have extra info like start_ns, end_ns,
> diff_ns.
> Those two can be specially useful for tree lock wait time.
> There is tool to utilize those two events already:
> https://github.com/adam900710/btrfs-profiler/blob/master/tree_lock_wait.py
> 
> The non-sleepable can be useful for possible user space based lock
> leakage/dead lock detector.
> 
> Changelog:
> v2:
> - Hide all ktime_get_ns() call out of trace events
>   So there will be no overhead if trace events are not enabled.
> 
> v3:
> - More output for human to take a glance
> - More trace events for later bcc usage
>   Like lock leakage and deadlock detection.

V3 looks good to me, thanks. The enhanced output of the sleepable lock
is still sane.
