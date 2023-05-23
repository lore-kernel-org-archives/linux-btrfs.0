Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA771C7EE23
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 11:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbjEWLsf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 07:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjEWLse (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 07:48:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC66D11A
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 04:48:32 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 23CEE68AFE; Tue, 23 May 2023 13:48:28 +0200 (CEST)
Date:   Tue, 23 May 2023 13:48:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: fix the btrfs_get_global_root return value
Message-ID: <20230523114827.GA29348@lst.de>
References: <20230523084020.336697-1-hch@lst.de> <4031cd58-dd4c-a0cb-79d4-38c7f03ceaf3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4031cd58-dd4c-a0cb-79d4-38c7f03ceaf3@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 23, 2023 at 07:37:23PM +0800, Anand Jain wrote:
> On 23/05/2023 16:40, Christoph Hellwig wrote:
>> btrfs_grab_root returns either the root or NULL, and the callers of
>> btrfs_get_global_root expect it to return the same.  But all the more
>> recently added roots instead return an ERR_PTR, so fix this.
>>
>
> Fix looks good. However, I'm curious about the Fixes commit
> you're referring to as the one this fix addresses...
>
>> Fixes: bcef60f24903 ("Btrfs: quota tree support and startup")
>
> btrfs_read_fs_root_no_name() return value used at that commit.

Indeed. open_ctree also used to check IS_ERR after the NULL check.
So while this commit was really odd in that it added the first ERR_PTR
return to the otherwise NULL as failure btrfs_read_fs_root_no_name,
that was actually handled.  Looks like the first fixes would be for
whoever dropped that check, but finding code removals in git-blame
tends to be a bit hard.  I'll see if I can track down the culprit.

Otherwise I'm fine with just dropping the extra Fixes tags.
