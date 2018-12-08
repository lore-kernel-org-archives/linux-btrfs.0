Return-Path: <SRS0=Boyq=OR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A8CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  8 Dec 2018 16:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9541F2081C
	for <linux-btrfs@archiver.kernel.org>; Sat,  8 Dec 2018 16:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9541F2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbeLHQR7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 8 Dec 2018 11:17:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:39676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726176AbeLHQR6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Dec 2018 11:17:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46664AECC;
        Sat,  8 Dec 2018 16:17:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4C72CDA7E4; Sat,  8 Dec 2018 17:17:37 +0100 (CET)
Date:   Sat, 8 Dec 2018 17:17:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181208161736.GI23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz>
 <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
 <20181208004737.GH23615@twin.jikos.cz>
 <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cea2079-cef5-6833-884d-a3c8edc4c14a@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Dec 08, 2018 at 08:50:32AM +0800, Qu Wenruo wrote:
> > I've adapted a stress tests that unpacks a large tarball, snaphosts
> > every 20 seconds, deletes a random snapshot every 50 seconds, deletes
> > file from the original subvolume, now enhanced with qgroups just for the
> > new snapshots inherigin the toplevel subvolume. Lockup.
> > 
> > It gets stuck in a snapshot call with the follwin stacktrace
> > 
> > [<0>] btrfs_tree_read_lock+0xf3/0x150 [btrfs]
> > [<0>] btrfs_qgroup_trace_subtree+0x280/0x7b0 [btrfs]
> 
> This looks like the original subtree tracing has something wrong.

Yes, I ran the test on current master and it locked up too, so it's not
due to your patchset.

> Thanks for the report, I'll investigate it.

Thanks.
