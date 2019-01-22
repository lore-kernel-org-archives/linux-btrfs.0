Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FD3C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C7020879
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfAVRsc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:48:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:56510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726147AbfAVRsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:48:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0851BAEB8
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 17:48:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 24D6DDA84A; Tue, 22 Jan 2019 18:47:56 +0100 (CET)
Date:   Tue, 22 Jan 2019 18:47:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
Message-ID: <20190122174756.GR2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118021956.22949-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
> Patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_tree_checker
> Which is based on v5.0-rc1 tag.
> 
> This patchset has the following two features:
> - Tree block validation output enhancement
>   * Output validation failure timing (write time or read time)
>   * Always output tree block level/key mismatch error message
>     This part is already submitted and reviewed.
> 
> - Write time tree block validation check
>   To catch memory corruption either from hardware or kernel.
>   Example output would be:
> 
>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>     BTRFS error (device dm-3): write time tree block corruption detected
>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>     BTRFS error (device dm-3): write time tree block corruption detected

Would it be possible to print this message only once? It's correct when
it's the last message after all the corruptions are detected as there
could be a lot of text that can scroll off the screen. The real reason
what happend would stay and give enough clue what happened.

>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
>     BTRFS info (device dm-3): forced readonly
>     BTRFS warning (device dm-3): Skipping commit of aborted transaction.
>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
>     BTRFS info (device dm-3): delayed_refs has NO entry

That's not from your patch es but now that I see it, it's not for the
'info' level, maybe 'debug' or not printed at all.

The extra checks will cause some slowdown, do we have an estimate how
much? 
