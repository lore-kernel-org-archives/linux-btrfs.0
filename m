Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FA8C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 02:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5B02080C
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 02:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5B02080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbeKTNL6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 08:11:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:13768 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbeKTNL6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 08:11:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2018 18:45:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,255,1539673200"; 
   d="scan'208";a="109949215"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.13.27])
  by orsmga002.jf.intel.com with ESMTP; 19 Nov 2018 18:45:04 -0800
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Omar Sandoval <osandov@osandov.com>, Jens Axboe <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "Mike Snitzer" <snitzer@redhat.com>, <dm-devel@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>,
        <linux-raid@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, Gao Xiang <gaoxiang25@huawei.com>,
        "Christoph Hellwig" <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        <linux-ext4@vger.kernel.org>, Coly Li <colyli@suse.de>,
        <linux-bcache@vger.kernel.org>, Boaz Harrosh <ooo@electrozaur.com>,
        "Bob Peterson" <rpeterso@redhat.com>, <cluster-devel@redhat.com>
Subject: Re: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
References: <20181115085306.9910-1-ming.lei@redhat.com>
        <20181115085306.9910-16-ming.lei@redhat.com>
        <20181116015936.GJ23828@vader> <20181119090415.GM16736@ming.t460p>
Date:   Tue, 20 Nov 2018 10:45:03 +0800
In-Reply-To: <20181119090415.GM16736@ming.t460p> (Ming Lei's message of "Mon,
        19 Nov 2018 17:04:16 +0800")
Message-ID: <87o9ak8o28.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> On Thu, Nov 15, 2018 at 05:59:36PM -0800, Omar Sandoval wrote:
>> On Thu, Nov 15, 2018 at 04:53:02PM +0800, Ming Lei wrote:
>> > Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
>> > increase BIO_MAX_PAGES for it.
>> 
>> You mentioned to it in the cover letter, but this needs more explanation
>> in the commit message. Why did CONFIG_THP_SWAP require > 256? Why does
>> multipage bvecs remove that requirement?
>
> CONFIG_THP_SWAP needs to split one TH page into normal pages and adds
> them all to one bio. With multipage-bvec, it just takes one bvec to
> hold them all.

Yes.  CONFIG_THP_SWAP needs to put 512 normal sub-pages into one bio to
write the 512 sub-pages together.  With the help of multipage-bvec, it
needs just bvect to hold 512 normal sub-pages.

Best Regards,
Huang, Ying

> thanks,
> Ming
