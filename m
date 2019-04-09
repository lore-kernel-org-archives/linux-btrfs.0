Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B160C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2257020651
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 09:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfDIJnE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 05:43:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:43116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726035AbfDIJnD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 05:43:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7692AF81
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Apr 2019 09:43:01 +0000 (UTC)
Date:   Tue, 9 Apr 2019 11:43:01 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal csum-dump'
 command
Message-ID: <20190409094301.GB5099@linux-x5ow.site>
References: <20190408133146.21355-1-jthumshirn@suse.de>
 <20190408133146.21355-2-jthumshirn@suse.de>
 <e8196cf2-983e-7e97-5bac-bad4cd3fbd47@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8196cf2-983e-7e97-5bac-bad4cd3fbd47@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 09, 2019 at 11:47:50AM +0300, Nikolay Borisov wrote:
[...]

> Overall looks good and not nearly as ugly as I expected so the csum tree
> is not _THAT_ cumbersome to work with after all :). However, do you
> intend to submit tests with files with specific patterns to ensure we do
> not regress? Also I have some minor comments below but they are mostly
> cosmetic so:

Yes test are planned, once I've figured out how to properly do this with
btrfs-progs test framework.

[...]

> In cmds-inspect-dump-super.c there is a function 'load_and_dump_sb', IMO
> it will make sense to split it into load_sb and dump/print_sb. That way
> the former could be made into a library function and moved to utils.c
> this will enable you to query the size of the csum dynamically.

Ah this is something I've been looking for. Thanks for the pointer will do it.

> 
> 
> > +	int ret, i, j;
> > +	u64 needle = phys;
> > +	u64 pending_csums = extent_csums;
> 
> Perhahps pending_csums could be renamed to something more descriptive e.g:
> 
> pending_csum_count
> 
> OTOH the plural form slightly hints at the possible usage but while I
> was reviewing the code I had to scroll up to be sure what the variable
> holds.

Sure, no problem.

> 
> > +
> > +	memset(buf, 0, sizeof(buf));
> > +	search = (struct btrfs_ioctl_search_args_v2 *)buf;
> > +	sk = &search->key;
> > +
> > +again:
> > +	if (debug)
> > +		printf(
> > +"Looking up checksums for extent at physial offset: %llu (searching at %llu), looking for %llu csums\n",
> > +		       phys, needle, pending_csums);
> > +
> > +	sk->tree_id = BTRFS_CSUM_TREE_OBJECTID;
> > +	sk->min_objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> > +	sk->max_objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> > +	sk->max_type = BTRFS_EXTENT_CSUM_KEY;
> > +	sk->min_type = BTRFS_EXTENT_CSUM_KEY;
> > +	sk->min_offset = needle;
> > +	sk->max_offset = (u64)-1;
> > +	sk->max_transid = (u64)-1;
> > +	sk->nr_items = 1;
> > +	search->buf_size = bufsz - sizeof(*search);
> > +
> > +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, search);
> > +	if (ret < 0)
> > +		return ret;
> > +> +	if (sk->nr_items == 0) {
> 
> I'd like a comment here that this is a heuristics

OK.

> 
> > +		needle -= 4096;
> > +		goto again;
> > +	}
> 
> nit: My personal preference is to always use the idiomatic constructs
> that a language gives to developers. I know it will increase the
> indentation level but a do {} while(!sk->nr_items) feels more correct
> than constant abuse of labels (and in the btrfs code base we are grave
> offenders in that regard. This is only my opinion so if David feels it'
> better to leave the label-based construct I'm not going to argue.

I personally prefer labels for cases like this, where it's the less likely
case. Plus it saves us one level of indentation. But I do what ever is
preferred here.

[...]

> > +		if (csums_in_item > pending_csums)
> > +			csums_in_item = pending_csums;
> 
> nit: csums_in_item = max(csums_in_item, pending_csums);

Args, yeah. Stupid me.

[...]
> > +	tmp = realloc(fiemap, sizeof(*fiemap) + ext_size);
> > +	if (!tmp)
> > +		goto free_fiemap;
> 
> That works but if a file has A LOT OF extents then this could
> potentially trigger a very large allocation. A different strategy is to
> have a fixed number of extents and read the whole file in a loop. This
> could of course be added later. Just mentioning it.

Yes I saw xfs_io's fiemap command does use batches, but we're in user-space
and with memory overcommit per default I don't think doing large allocations
in a debug/diagnostics tool hurts too much. I can easily transform it to
batched allocations + queries though if you want though.

Thanks for the review,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
