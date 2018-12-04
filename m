Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BAAC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0290C2087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0290C2087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbeLDKTL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:19:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbeLDKTK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:19:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEE5DAE60;
        Tue,  4 Dec 2018 10:19:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 92D7CDA907; Tue,  4 Dec 2018 11:18:49 +0100 (CET)
Date:   Tue, 4 Dec 2018 11:18:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
Message-ID: <20181204101847.GE17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com>
 <e40b8c45-2c16-35c0-c583-ca33c1500b97@suse.com>
 <c9f75bee-67f8-79a8-d66c-cffc9c828264@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f75bee-67f8-79a8-d66c-cffc9c828264@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 04:50:57PM +0800, Qu Wenruo wrote:
> >> -static int fixup_devices(struct btrfs_fs_info *fs_info,
> >> -			 struct mdrestore_struct *mdres, off_t dev_size)
> >> +static int fixup_device_size(struct btrfs_trans_handle *trans,
> >> +			     struct mdrestore_struct *mdres,
> >> +			     off_t dev_size)
> >>  {
> >> -	struct btrfs_trans_handle *trans;
> >> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> >>  	struct btrfs_dev_item *dev_item;
> >>  	struct btrfs_path path;
> >> -	struct extent_buffer *leaf;
> >>  	struct btrfs_root *root = fs_info->chunk_root;
> >>  	struct btrfs_key key;
> >> +	struct extent_buffer *leaf;
> > 
> > nit: Unnecessary change
> 
> Doesn't it look better when all btrfs_ prefix get batched together? :)

Please don't do unrelated changes like that.
