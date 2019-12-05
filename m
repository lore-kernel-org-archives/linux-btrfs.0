Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC873C43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED97206D9
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbfLERk4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:40:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:36112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729598AbfLERk4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 12:40:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08D7FAF65;
        Thu,  5 Dec 2019 17:40:55 +0000 (UTC)
Date:   Thu, 5 Dec 2019 18:40:53 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        fdmanana@kernel.org, nborisov@suse.com, dsterba@suse.cz,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 4/8] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20191205174053.GD19670@Johanness-MacBook-Pro.local>
References: <20191205155630.28817-1-rgoldwyn@suse.de>
 <20191205155630.28817-5-rgoldwyn@suse.de>
 <20191205171815.GA19670@Johanness-MacBook-Pro.local>
 <20191205171959.GA8586@infradead.org>
 <20191205173242.GB19670@Johanness-MacBook-Pro.local>
 <20191205173346.GA26969@infradead.org>
 <20191205173648.GC19670@Johanness-MacBook-Pro.local>
 <20191205173728.GA32341@infradead.org>
 <20191205173743.GB32341@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205173743.GB32341@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 05, 2019 at 09:37:43AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 05, 2019 at 09:37:28AM -0800, Christoph Hellwig wrote:
> > On Thu, Dec 05, 2019 at 06:36:48PM +0100, Johannes Thumshirn wrote:
> > > To hide the implementation details and not provoke someone yelling layering
> > > violation?
> > 
> > The only layering is ->direct_IO, and this is a step to get rid of that
> > junk..
> 
> s/layering/layering violation/

OK I admit defeat.

Byte,
	Johannes
