Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BA8C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 787892173C
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfDFN0p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 09:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfDFN0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 09:26:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 566BE3082E1E;
        Sat,  6 Apr 2019 13:26:45 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CA4626350;
        Sat,  6 Apr 2019 13:26:38 +0000 (UTC)
Date:   Sat, 6 Apr 2019 21:26:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: No way to break bio_for_each_segment_all() macro?
Message-ID: <20190406132630.GB3018@ming.t460p>
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 06 Apr 2019 13:26:45 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 09:53:07AM +0800, Qu Wenruo wrote:
> Hi,
> 
> I'm looking into a strange behavior that we can't break
> bio_for_each_segment_all() after commit 6dc4f100c175 ("block: allow
> bio_for_each_segment_all() to iterate over multi-page bvec").
> 
> It's screwing up all bio_for_each_segment_all() call with error out branch.
> 
> 
> There is one relatively easy to trigger setup.
> 
> Here is my kernel branch, which is based on David Sterb's misc-next branch:
> https://github.com/adam900710/linux/tree/tree_checker_testing
> 
> It's just two commits ahead.
> 
> Then some debug diff:
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c2c0640aea55..05c880a5254b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -851,16 +851,22 @@ static blk_status_t btree_csum_one_bio(struct bio
> *bio)
>         struct bio_vec *bvec;
>         struct btrfs_root *root;
>         int i, ret = 0;
> +       int err = 0;
>         struct bvec_iter_all iter_all;
> 
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
>         bio_for_each_segment_all(bvec, bio, i, iter_all) {
>                 root = BTRFS_I(bvec->bv_page->mapping->host)->root;
>                 ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
> -               if (ret)
> +               if (ret) {
> +                       err = ret;
> +                       pr_info("breaking out with ret=%d\n", ret);
>                         break;
> +               }
>         }
> 
> +       if (err)
> +               pr_info("err=%d out, but ret=%d\n",err, ret);
>         return errno_to_blk_status(ret);
>  }
> 
> Straightforward, if we break, we should have err == ret.
>

Thanks for the report, and it should be easy to fix, will post patch
soon.

Thanks,
Ming
