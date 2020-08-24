Return-Path: <SRS0=zwl1=CC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B051C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FBD207D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHXLbz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 07:31:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:34234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgHXLbr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Aug 2020 07:31:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 11525AB7D;
        Mon, 24 Aug 2020 11:32:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 69600DA730; Mon, 24 Aug 2020 13:30:36 +0200 (CEST)
Date:   Mon, 24 Aug 2020 13:30:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/2] btrfs: pretty print leaked root name
Message-ID: <20200824113036.GI2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1597953516.git.josef@toxicpanda.com>
 <461693e5c015857e684878e99e5e65075bb97c13.1597953516.git.josef@toxicpanda.com>
 <d98bb04e-1bcf-80c7-26ae-e91f3ecfd818@suse.com>
 <20200821101301.GC2026@twin.jikos.cz>
 <cff7de4d-e4de-01cf-62b2-3de0b9e51eb2@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff7de4d-e4de-01cf-62b2-3de0b9e51eb2@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Aug 21, 2020 at 10:00:35AM -0400, Josef Bacik wrote:
> On 8/21/20 6:13 AM, David Sterba wrote:
> > On Fri, Aug 21, 2020 at 10:35:38AM +0300, Nikolay Borisov wrote:
> >>>   		root = list_first_entry(&fs_info->allocated_roots,
> >>>   					struct btrfs_root, leak_list);
> >>> -		btrfs_err(fs_info, "leaked root %llu-%llu refcount %d",
> >>> -			  root->root_key.objectid, root->root_key.offset,
> >>> -			  refcount_read(&root->refs));
> >>> +		btrfs_err(fs_info, "leaked root %s%lld-%llu refcount %d",
> >>
> >> nit: Won't this string result in some rather awkward looking strings,
> >> such as:
> >>
> >> "leaked root ROOT_TREE<objectid>-<offset>..." i.e shouldn't the
> >> (objectid,offset) pair be marked with parentheses?
> > 
> > I don't understand why need/want to print the offset here. It is from
> > the key.offset but for a message we should print it in an understandable
> > way.
> 
> The offset matters for the TREE_RELOC roots, because it's the object id 
> of the fs root that the reloc root refers to.  Thanks,

Ok, that makes sense to print, though printing it as offset=... looks
confusing. Could it be rephrased to refer to the fs tree and reloc tree?
