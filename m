Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE51C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 13:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CEDB20831
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 13:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CEDB20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbeKTAId (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 19:08:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:49318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbeKTAId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:08:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 343A0AD56
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 13:44:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D0552DAF89; Mon, 19 Nov 2018 14:44:34 +0100 (CET)
Date:   Mon, 19 Nov 2018 14:44:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] FSID change kernel support
Message-ID: <20181119134434.GB24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1540910608-4121-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540910608-4121-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 04:43:22PM +0200, Nikolay Borisov wrote:
> Here is the 3rd submission for the kernel counterpart of the uuid change 
> patchset. The only difference is that I (hope) have adressed all cosmetic 
> feedback from David as well as have reworded some change logs to ease 
> understanding. I've also re-run the regression tests and no failure were 
> obsered. 
> 
> For background information refer to first posting [0] and the second one [1]
> 
> [0] https://lore.kernel.org/linux-btrfs/1535531754-29774-1-git-send-email-nborisov@suse.com/
> [1] https://lore.kernel.org/linux-btrfs/1539270244-27076-1-git-send-email-nborisov@suse.com/
> 
> Nikolay Borisov (6):
>   btrfs: Introduce support for FSID change without metadata rewrite
>   btrfs: Remove fsid/metadata_fsid fields from btrfs_info
>   btrfs: Add handling for disk split-brain scenario during fsid change
>   btrfs: Introduce 2 more members to struct btrfs_fs_devices
>   btrfs: Handle one more split-brain scenario during fsid change
>   btrfs: Handle final split-brain possibility during fsid change

I'm going to move this patchset from for-next to misc-next, the
userspace part is on the way to devel so we should be good for more
testing.

There are still some usability issues that I found during testing, that
can be fixed after the core is merged:

- metadata_uuid is missing sysfs export (+ btrfs-progs documentation)
- btrfstune -m/-M needs more verbose output, similar to -u/-U

d.
