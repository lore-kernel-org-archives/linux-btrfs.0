Return-Path: <SRS0=wPs8=3K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A7BC2D0CE
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jan 2020 15:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577FE21569
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jan 2020 15:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUPRK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 10:17:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:47072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgAUPRK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jan 2020 10:17:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0BD53AC4A;
        Tue, 21 Jan 2020 15:17:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8EBCADA738; Tue, 21 Jan 2020 16:16:51 +0100 (CET)
Date:   Tue, 21 Jan 2020 16:16:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Handle another split brain scenario with
 metadata uuid feature
Message-ID: <20200121151651.GW3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200110121135.7386-1-nborisov@suse.com>
 <20200110121135.7386-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110121135.7386-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 10, 2020 at 02:11:34PM +0200, Nikolay Borisov wrote:
>  	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
> -		if (memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
> -			   BTRFS_FSID_SIZE) != 0 &&
> -		    memcmp(fs_devices->metadata_uuid, disk_super->metadata_uuid,
> -			   BTRFS_FSID_SIZE) == 0 &&
> -		    memcmp(fs_devices->fsid, disk_super->fsid,
> -			   BTRFS_FSID_SIZE) != 0) {
> +		bool changed_fsdevices =
> +			memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
> +			       BTRFS_FSID_SIZE) != 0 &&
> +			memcmp(fs_devices->metadata_uuid,
> +			       disk_super->metadata_uuid, BTRFS_FSID_SIZE) == 0 &&
> +			memcmp(fs_devices->fsid, disk_super->fsid, BTRFS_FSID_SIZE) != 0;
> +
> +		bool unchanged_fsdevices =
> +			memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
> +						  BTRFS_FSID_SIZE) == 0 &&
> +			memcmp(fs_devices->fsid, disk_super->metadata_uuid, BTRFS_FSID_SIZE) == 0;
> +		if (changed_fsdevices || unchanged_fsdevices)
>  			return fs_devices;

This is ugly, I've converted it to if (memcmp) and dropped the
variables.
