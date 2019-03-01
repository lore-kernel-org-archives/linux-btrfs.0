Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E5C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8FB12083D
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbfCAQZ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:25:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:57420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388450AbfCAQZ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 11:25:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 86D88AEA2
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2019 16:25:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 94C6BDA851; Fri,  1 Mar 2019 17:26:44 +0100 (CET)
Date:   Fri, 1 Mar 2019 17:26:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Port kernel fs_devices::total_rw_bytes
 to btrfs-progs
Message-ID: <20190301162644.GS31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190205065312.19743-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205065312.19743-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 02:53:11PM +0800, Qu Wenruo wrote:
> Unlike kernel, btrfs-progs doesn't (yet) support devices grow/shrink,
> the port only needs to handle open_ctree() time initialization (at
> read_one_dev()), and btrfs_add_device() used for mkfs.
> 
> This provide the basis for incoming unification of chunk allocator
> behavior.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1 and 2 applied, thanks.
