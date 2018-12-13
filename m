Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C678C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 19:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4401720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 19:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4401720811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbeLMTPG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 14:15:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:40936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727608AbeLMTPF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 14:15:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39003AF1A
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 19:15:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81E24DA7EE; Thu, 13 Dec 2018 20:14:42 +0100 (CET)
Date:   Thu, 13 Dec 2018 20:14:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] FSID change userspace v2
Message-ID: <20181213191442.GM23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 06:03:56PM +0300, Nikolay Borisov wrote:
> Here is the second posting of the FSID change support for user space. For 
> background information refer to the the initial posting [0]. The major changes
> in this version are: 
>  - Modified the sequence of operations when changing the fsid. Now it's split
>  among 2 transactions with the first one setting a flag (similarly to what 
>  the old fsid change code does) and the second transaction applying the new 
>  FSID and incompat flag
> 
>  - Expanded the test coverage with several crafted images which simulate 
>  failure scenarios that could occur while fsid change is in progress. 
> 
>  - Also added the last 2 clean up patches which can be merged independently of
>  the fsid changes.
> 
> 
> 
> [0] https://lore.kernel.org/linux-btrfs/1535531754-29774-1-git-send-email-nborisov@suse.com/
> Nikolay Borisov (8):
>   btrfstune: Remove fs_info arg from change_device_uuid
>   btrfstune: Rename change_header_uuid to change_buffer_header_uuid
>   btrfs-progs: Add support for metadata_uuid field.
>   btrfstune: Add support for changing the user uuid
>   btrfs-progs: tests: Add tests for changing fsid feature
>   btrfs-progs: Remove fsid/metdata_uuid fields from fs_info
>   btrfs-progs: Remove btrfs_fs_info::new_fsid
>   btrfs-progs: Directly pass root to change_devices_uuid

Added to devel, thanks.
