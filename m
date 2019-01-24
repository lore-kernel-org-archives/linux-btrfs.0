Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3281FC282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 15:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CF402184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 15:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfAXPVD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:21:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:51432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727562AbfAXPVD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 10:21:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EBFCAF03;
        Thu, 24 Jan 2019 15:21:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EABB4DA6F5; Thu, 24 Jan 2019 16:20:29 +0100 (CET)
Date:   Thu, 24 Jan 2019 16:20:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
Message-ID: <20190124152029.GX2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
 <20190123171635.GU2900@twin.jikos.cz>
 <0feee626-6d73-ba40-2e31-112ae5337f8d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0feee626-6d73-ba40-2e31-112ae5337f8d@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 24, 2019 at 11:04:47AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/24 上午1:16, David Sterba wrote:
> > On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
> >> Patchset can be fetched from github:
> >> https://github.com/adam900710/linux/tree/write_time_tree_checker
> >> Which is based on v5.0-rc1 tag.
> >>
> >> This patchset has the following two features:
> >> - Tree block validation output enhancement
> >>   * Output validation failure timing (write time or read time)
> >>   * Always output tree block level/key mismatch error message
> >>     This part is already submitted and reviewed.
> >>
> >> - Write time tree block validation check
> >>   To catch memory corruption either from hardware or kernel.
> >>   Example output would be:
> >>
> >>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
> >>     BTRFS error (device dm-3): write time tree block corruption detected
> >>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
> >>     BTRFS error (device dm-3): write time tree block corruption detected
> >>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
> >>     BTRFS info (device dm-3): forced readonly
> >>     BTRFS warning (device dm-3): Skipping commit of aborted transaction.
> >>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
> >>     BTRFS info (device dm-3): delayed_refs has NO entry
> > 
> > Two tests complain:
> 
> Any info about the reproducibility and VM/hardware info? Especially for
> the VM ram size.

2G ram with 4 cpus, this was first run of the patchset so I can't say
how reliable it is yet.
