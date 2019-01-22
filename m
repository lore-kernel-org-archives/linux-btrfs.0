Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E4FC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 640CB2085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfAVQdf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:33:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:44798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbfAVQdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 11:33:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1247BB081
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 16:33:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ADD6FDA84A; Tue, 22 Jan 2019 17:32:59 +0100 (CET)
Date:   Tue, 22 Jan 2019 17:32:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
Message-ID: <20190122163258.GM2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:16:00PM +0800, Qu Wenruo wrote:
> And to co-operate this, also delayed btrfs_drop_snapshot() call on reloc
> tree, btrfs_drop_snapshot() call will also be delayed to
> clean_dirty_subvs().

Can you please rephrase this paragraph?

> This patch will increase the size of btrfs_root by 16 bytes.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

> +static int clean_dirty_subvs(struct reloc_control *rc)
> +{
> +	struct btrfs_root *root;
> +	struct btrfs_root *next;
> +	int err = 0;
> +	int ret;
> +
> +	list_for_each_entry_safe(root, next, &rc->dirty_subv_roots,
> +				 reloc_dirty_list) {
> +		struct btrfs_root *reloc_root = root->reloc_root;
> +
> +		clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
> +		list_del_init(&root->reloc_dirty_list);
> +		root->reloc_root = NULL;
> +		if (reloc_root) {
> +			ret = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
> +			if (ret < 0 && !err)
> +				err = ret;
> +		}
> +		btrfs_put_fs_root(root);
> +	}
> +	return err;

Please dont use the err/ret style but 'ret' that matches function return
type and for the temporary return values ret2 etc.

> +}
