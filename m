Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D272EC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F79920870
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F79920870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbeLMQtl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:49:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:41128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727511AbeLMQtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 11:49:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59309AD2C;
        Thu, 13 Dec 2018 16:49:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8EAC3DA7EE; Thu, 13 Dec 2018 17:49:17 +0100 (CET)
Date:   Thu, 13 Dec 2018 17:49:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 05/10] btrfs: introduce delayed_refs_rsv
Message-ID: <20181213164917.GI23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-6-josef@toxicpanda.com>
 <b9d58b65-cccd-4e66-ae1c-15847f947a62@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9d58b65-cccd-4e66-ae1c-15847f947a62@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 04:45:37PM +0200, Nikolay Borisov wrote:
> > @@ -5819,9 +5953,10 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
> >  	fs_info->trans_block_rsv.space_info = space_info;
> >  	fs_info->empty_block_rsv.space_info = space_info;
> >  	fs_info->delayed_block_rsv.space_info = space_info;
> > +	fs_info->delayed_refs_rsv.space_info = space_info;
> >  
> > -	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
> > -	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
> > +	fs_info->extent_root->block_rsv = &fs_info->delayed_refs_rsv;
> > +	fs_info->csum_root->block_rsv = &fs_info->delayed_refs_rsv;
> 
> nit: Some whitespace damage

No, the removed part is global_block_rsv and added is delayed_refs_rsv.
