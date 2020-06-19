Return-Path: <SRS0=CkC6=AA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848C2C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 09:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647E220786
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 09:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgFSJjQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 05:39:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:35660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgFSJjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jun 2020 05:39:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CFF4ACE1;
        Fri, 19 Jun 2020 09:39:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 47C3FDA9B9; Fri, 19 Jun 2020 11:39:03 +0200 (CEST)
Date:   Fri, 19 Jun 2020 11:39:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: add sysfs interface for debug
Message-ID: <20200619093903.GB27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200619015946.65638-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619015946.65638-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 19, 2020 at 09:59:46AM +0800, Qu Wenruo wrote:
> This patch will add the following sysfs interface:
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/rfer
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/excl
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/max_rfer
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/max_excl
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/lim_flags
>  ^^^ Above are already in "btrfs qgroup show" command output ^^^
> 
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/rsv_data
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/rsv_meta_pertrans
> /sys/fs/btrfs/<UUID>/qgroups/<qgroup_id>/rsv_meta_prealloc
> 
> The last 3 rsv related members are not visible to users, but can be very
> useful to debug qgroup limit related bugs.
> 
> Also, to avoid '/' used in <qgroup_id>, the seperator between qgroup
> level and qgroup id is changed to '_'.
> 
> The interface is not hidden behind 'debug' as I want this interface to
> be included into production build so we could have an easier life to
> debug qgroup rsv related bugs.

But why do you want to export it to sysfs at all?
