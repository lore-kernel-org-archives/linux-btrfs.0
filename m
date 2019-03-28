Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5A6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 16:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 570EE20823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 16:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfC1Q5i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 12:57:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfC1Q5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 12:57:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC128AB87;
        Thu, 28 Mar 2019 16:57:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6A169DA8D8; Thu, 28 Mar 2019 17:58:45 +0100 (CET)
Date:   Thu, 28 Mar 2019 17:58:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Yoon Jungyeon <jungyeon@gatech.edu>
Subject: Re: [PATCH 1/3] btrfs: tree-checker: Verify chunk items
Message-ID: <20190328165843.GP29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190308072929.30863-1-wqu@suse.com>
 <20190308072929.30863-2-wqu@suse.com>
 <913bed07-e9a0-14ed-1602-e4a5f206e303@suse.com>
 <95e0667a-0004-bec0-03c3-1708ab013320@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e0667a-0004-bec0-03c3-1708ab013320@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 03:58:24PM +0800, Qu Wenruo wrote:
> Should we put kernel test cases into btrfs-progs?

We collect all the images in btrfs-progs.

> We have fuzzed test groups for btrfs-progs mainly, but we don't really
> have kernel tests in btrfs-progs.
> Is it proper to put kernel-crashing tests into btrfs-progs?

Yes, but they should not be run by default. Currently there's not even a
test script for mounting the images. But the testsuite can be run
independently in a VM so the kernel tests make sense too.

> If not, where should we put such tests?
> 
> And BTW, I originally wanted to craft the minimal image for those tests,
> but quite a lot of the image needs several corruption combined to hit
> the pitfall. I'm not sure if it's worthy to create the minimal image.

That probably depends how much other work does the minimal image save.
The plan is to use python-btrfs to craft the images on-the-fly. We could
do that by specific tools written in C or enhance btrfs-corroupt-block,
but I'm strongly in favor of the python way due to simplicity.

Another way is to use the script only to generate the image and then
store it for tests to avoid the run-time dependency on python-btrfs.
