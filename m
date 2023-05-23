Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8604C77B75
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 11:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbjEWLyf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbjEWLye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 07:54:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBC618F
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 04:54:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C192D6732D; Tue, 23 May 2023 13:54:25 +0200 (CEST)
Date:   Tue, 23 May 2023 13:54:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/16] btrfs: factor out a btrfs_verify_page helper
Message-ID: <20230523115425.GA30209@lst.de>
References: <20230523081322.331337-1-hch@lst.de> <20230523081322.331337-3-hch@lst.de> <7d1d512a-e4d6-70c1-93c9-61800955b4b0@oracle.com> <20230523113907.GB28908@lst.de> <e3fc220d-3229-454c-6106-bc705490f05e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3fc220d-3229-454c-6106-bc705490f05e@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 23, 2023 at 07:47:14PM +0800, Anand Jain wrote:
>
>
> On 23/05/2023 19:39, Christoph Hellwig wrote:
>> On Tue, May 23, 2023 at 06:16:25PM +0800, Anand Jain wrote:
>>>>    +static int btrfs_verify_page(struct page *page, u64 start)
>>>
>>>   Did you consider making it an inline function?
>>
>> No, why?
>
> As the compiler optimization may or may not inline it?

And making that decision is in general the compilers job.  I don't
see a need to second guess the compiler here.
