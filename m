Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C29C6FD1C
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Mar 2023 18:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCFSNy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjCFSNb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2023 13:13:31 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5B11BD
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2023 10:12:52 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9E72268B05; Mon,  6 Mar 2023 17:57:59 +0100 (CET)
Date:   Mon, 6 Mar 2023 17:57:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/10] btrfs: return a btrfs_bio from btrfs_bio_alloc
Message-ID: <20230306165759.GA683@lst.de>
References: <20230301134244.1378533-1-hch@lst.de> <20230301134244.1378533-10-hch@lst.de> <73a37af8-01cf-38fd-988c-b72dc41f2a58@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73a37af8-01cf-38fd-988c-b72dc41f2a58@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 04, 2023 at 06:48:54AM +0800, Anand Jain wrote:
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
>
>
> -	struct bio *bio;
> +	struct btrfs_bio *bbio;
>
> Here, dereferenced for bio from %bbio appears more than once.
> I am curious why you didn't choose to initialize the bio instead.

As this is a bit of a theme here:  I prefer to not add a local variable
if there's less than about half a dozen dereference in the code, and
the dereferences aren't too long.  If there is a general consensus to
add a more local variables I can do that, but it doesn't feel helpful
to me.
