Return-Path: <SRS0=Boyq=OR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1134C07E85
	for <linux-btrfs@archiver.kernel.org>; Sat,  8 Dec 2018 00:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4C42081C
	for <linux-btrfs@archiver.kernel.org>; Sat,  8 Dec 2018 00:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F4C42081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbeLHAr7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 19:47:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:46732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbeLHAr7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 19:47:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85303AFC8;
        Sat,  8 Dec 2018 00:47:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C6323DA7B4; Sat,  8 Dec 2018 01:47:37 +0100 (CET)
Date:   Sat, 8 Dec 2018 01:47:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181208004737.GH23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz>
 <20181206193511.GF23615@twin.jikos.cz>
 <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d52fa1bb-601a-25ee-d256-dbf05213ec9d@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 06:51:21AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/12/7 上午3:35, David Sterba wrote:
> > On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
> >> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
> >>> This patchset can be fetched from github:
> >>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebased
> >>>
> >>> Which is based on v4.20-rc1.
> >>
> >> Thanks, I'll add it to for-next soon.
> > 
> > The branch was there for some time but not for at least a week (my
> > mistake I did not notice in time). I've rebased it on top of recent
> > misc-next, but without the delayed refs patchset from Josef.
> > 
> > At the moment I'm considering it for merge to 4.21, there's still some
> > time to pull it out in case it shows up to be too problematic. I'm
> > mostly worried about the unknown interactions with the enospc updates or
> 
> For that part, I don't think it would have some obvious problem for
> enospc updates.
> 
> As the user-noticeable effect is the delay of reloc tree deletion.
> 
> Despite that, it's mostly transparent to extent allocation.
> 
> > generally because of lack of qgroup and reloc code reviews.
> 
> That's the biggest problem.
> 
> However most of the current qgroup + balance optimization is done inside
> qgroup code (to skip certain qgroup record), if we're going to hit some
> problem then this patchset would have the highest possibility to hit
> problem.
> 
> Later patches will just keep tweaking qgroup to without affecting any
> other parts mostly.
> 
> So I'm fine if you decide to pull it out for now.

I've adapted a stress tests that unpacks a large tarball, snaphosts
every 20 seconds, deletes a random snapshot every 50 seconds, deletes
file from the original subvolume, now enhanced with qgroups just for the
new snapshots inherigin the toplevel subvolume. Lockup.

It gets stuck in a snapshot call with the follwin stacktrace

[<0>] btrfs_tree_read_lock+0xf3/0x150 [btrfs]
[<0>] btrfs_qgroup_trace_subtree+0x280/0x7b0 [btrfs]
[<0>] do_walk_down+0x681/0xb20 [btrfs]
[<0>] walk_down_tree+0xf5/0x1c0 [btrfs]
[<0>] btrfs_drop_snapshot+0x43b/0xb60 [btrfs]
[<0>] btrfs_clean_one_deleted_snapshot+0xc1/0x120 [btrfs]
[<0>] cleaner_kthread+0xf8/0x170 [btrfs]
[<0>] kthread+0x121/0x140
[<0>] ret_from_fork+0x27/0x50

and that's like 10th snapshot and ~3rd deltion. This is qgroup show:

qgroupid         rfer         excl parent
--------         ----         ---- ------
0/5         865.27MiB      1.66MiB ---
0/257           0.00B        0.00B ---
0/259           0.00B        0.00B ---
0/260       806.58MiB    637.25MiB ---
0/262           0.00B        0.00B ---
0/263           0.00B        0.00B ---
0/264           0.00B        0.00B ---
0/265           0.00B        0.00B ---
0/266           0.00B        0.00B ---
0/267           0.00B        0.00B ---
0/268           0.00B        0.00B ---
0/269           0.00B        0.00B ---
0/270       989.04MiB      1.22MiB ---
0/271           0.00B        0.00B ---
0/272       922.25MiB    416.00KiB ---
0/273       931.02MiB      1.50MiB ---
0/274       910.94MiB      1.52MiB ---
1/1           1.64GiB      1.64GiB
0/5,0/257,0/259,0/260,0/262,0/263,0/264,0/265,0/266,0/267,0/268,0/269,0/270,0/271,0/272,0/273,0/274

No IO or cpu activity at this point, the stacktrace and show output
remains the same.

So, considering this, I'm not going to add the patchset to 4.21 but will
keep it in for-next for testing, any fixups or updates will be applied.
