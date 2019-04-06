Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2CEC282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9319D218A6
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 02:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfDFCBU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 22:01:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49060 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfDFCBU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 22:01:20 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hCady-0007mH-Mt; Sat, 06 Apr 2019 02:01:18 +0000
Date:   Sat, 6 Apr 2019 03:01:18 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        ming.lei@redhat.com
Subject: Re: No way to break bio_for_each_segment_all() macro?
Message-ID: <20190406020118.GL2217@ZenIV.linux.org.uk>
References: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2ba6e0-5312-1ec5-471e-edd16d6cde3a@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> Then run fstests btrfs/151, which will trigger a false alert in
> tree-checker:
> 
>   BTRFS critical (device dm-1): corrupt leaf: root=3 block=570572800
> slot=1 devid=1 invalid total bytes: have 0
>   BTRFS error (device dm-1): block=570572800 write time tree block
> corruption detected
>   breaking out with ret=-117
>   err=-117 out, but ret=0
> 
> So it looks like the break line doens't really break, but continue
> executing.

It expands to for-inside-for since that commit, so break only takes you
out of the inner loop...

No comments on desirability of such macros - personally, I prefer to
avoid those, but I'm not stepping into that holy war...
