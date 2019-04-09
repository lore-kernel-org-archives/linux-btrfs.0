Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C571EC10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD1C20830
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfDIKam (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:30:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51590 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbfDIKal (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 06:30:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96B14AEF1;
        Tue,  9 Apr 2019 10:30:40 +0000 (UTC)
Date:   Tue, 9 Apr 2019 12:30:39 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Su Yue <Damenly_Su@gmx.com>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal csum-dump'
 command
Message-ID: <20190409103039.GD5099@linux-x5ow.site>
References: <20190408133146.21355-1-jthumshirn@suse.de>
 <20190408133146.21355-2-jthumshirn@suse.de>
 <adb47c0d-6c71-3b34-7f20-7764bc16e036@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adb47c0d-6c71-3b34-7f20-7764bc16e036@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 09, 2019 at 05:34:22PM +0800, Su Yue wrote:
> 
> 
> On 2019/4/8 9:31 PM, Johannes Thumshirn wrote:
> > Add a 'btrfs inspect-internal csum-dump' command to dump the on-disk
> > checksums of a file.
> > 
> > The dump command first uses the FIEMAP ioctl() to get a map of the file's
> > extents and then uses the BTRFS_TREE_SEARCH_V2 ioctl() to get the
> > checksums for these extents.
> > 
> > Using FIEMAP instead of the BTRFS_TREE_SEARCH_V2 ioctl() to get the
> > extents allows us to quickly filter out any holes in the file, as this is
> > already done for us in the kernel.
> > 
> 
> Looks much better than V1. Some comments bellow.
> 

Thanks.

[...]

> > +	fiemap = calloc(1, sizeof(*fiemap));
> > +	if (!fiemap)
> > +		return -1;
> 
> -ENOMEM is better.

OK.

> > +
> > +	fiemap->fm_length = ~0;
> > +
> > +	ret = ioctl(fd, FS_IOC_FIEMAP, fiemap);
> > +	if (ret)
> > +		goto free_fiemap;
> > +
> > +	ext_size = fiemap->fm_mapped_extents * sizeof(struct fiemap_extent);
> > +
> > +	tmp = realloc(fiemap, sizeof(*fiemap) + ext_size);
> > +	if (!tmp)
> 
> ret = -ENOMEM;
> else btrfs_get_extent_csum() will return 0.
> 

Good catch, thanks

[...]

> > +	fd = open(filename, O_RDONLY);
> > +	if (fd < 0) {
> > +		error("cannot open file %s:%m\n", filename);
> 
> error() does break a line, no need of '\n'.
> > +		return 1;
> 
> -errno is better here.

OK.
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
