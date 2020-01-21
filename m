Return-Path: <SRS0=wPs8=3K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8645C2D0CE
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jan 2020 15:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B916024125
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jan 2020 15:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAUPYB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 10:24:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:53794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgAUPYB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jan 2020 10:24:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 970A5B121;
        Tue, 21 Jan 2020 15:23:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 16B0BDA738; Tue, 21 Jan 2020 16:23:44 +0100 (CET)
Date:   Tue, 21 Jan 2020 16:23:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] More split-brain fixes for metadata uuid feature
Message-ID: <20200121152343.GX3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200110121135.7386-1-nborisov@suse.com>
 <20200114171403.GH3929@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114171403.GH3929@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 14, 2020 at 06:14:03PM +0100, David Sterba wrote:
> On Fri, Jan 10, 2020 at 02:11:31PM +0200, Nikolay Borisov wrote:
> > Here are 4 patches which fix a newly found split-brain scenario in the
> > METADATA_UUID_INCOMPAT code. They are mostly the identical with Su's
> > original submission but I have reworked the changelogs and some function
> > names. Hence, I retained his authorship of the patches.
> > 
> > First 2 patches factor out some code with the hopes of making find_fisd a bit
> > more readable and simplifying the myriad of nested 'if' in device_list_add.
> > 
> > Patch 3 extends find_fsid_changed to handle the case where a disk with
> > METADATA_UUID_INCOMPAT and FSID_CHANGING_IN_PROGRESS is scanned after a disk
> > which has successfully been switched to FSID == METADATA_UUID state and has
> > created btrfs_fs_devices.
> > 
> > Patch 4 handles the counterpart situation - a fully switched disk is scanned
> > after one which has had METADATA_UUID_INCOMPAT and FSID_CHANGING_IN_PROGRESS
> > set.
> > 
> > This series should be applied to stable branches following 5.0 when the
> > metadata_uuid feature got introduced.
> > 
> > This patchset was tested with btrfs-progs' misc 034-metadata-uuid test and a full
> > xfstest run with no regressions. I will also be sending an improvement to the
> > test case which exercises the newly added code.
> > 
> >   btrfs: Call find_fsid from find_fsid_inprogress
> >   btrfs: Factor out metadata_uuid code from find_fsid.
> >   btrfs: Handle another split brain scenario with metadata uuid feature
> >   btrfs: Fix split-brain handling when changing FSID to metadata uuid
> 
> I'm adding it to for-next, thanks.

Moving to misc-next.
