Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3256C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8063E208E7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+JWvV79"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8063E208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbeJENpJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 09:45:09 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35162 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbeJENpJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 09:45:09 -0400
Received: by mail-yw1-f68.google.com with SMTP id y76-v6so4846410ywd.2;
        Thu, 04 Oct 2018 23:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91QKsv4mZCSLehtFbFfOeUG2F4g7OtJputLuH2xT8Ao=;
        b=B+JWvV79X4VMvA5Zcau3dia3CWCj+qDTXxxJ1sYKoGw5iyUzrU8s+ht5eYacKDREnd
         0IINlnK3YuTEdEYQkZst+YM0R9Yq3uWbNAs0hcC9n3tuykJ7cqFJGAe8k3hNCmyyRTEj
         E4Zl2uDDd0ONspqzIjMHrwyqihQ/jp03dxpPAwTkkBO6Mo/de4ehIHcY4PAqlPxxJ3P0
         83Pv7BlaZgD+Fwmtxa7FtidQ4/b4dR+va/bkaL4xI6hRhOtouBn+yEc1wWNZUb2dSYk0
         Cl00E0x7Vl4L/9qkQNYbkcx2vVBCiYZ5C1Uf5EjNnBvF2Lgq8A9/WVrF6XDDk2lwMmqy
         FRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91QKsv4mZCSLehtFbFfOeUG2F4g7OtJputLuH2xT8Ao=;
        b=pQ2VCHWq0KTAGPu93eg7oSovN04vVO9uhqje2fFuRboXgHKc6U4xxH7GxmZBosAnrt
         E5RhTF/AYECJYdrbBsnfcmxdZeRbdrja94A8izb1/n4tWc+EqKYxBghV2/yL469pULXN
         7GDCATy1gvou4Rea37en8cWkBzNJzrcNYhJ5QiTA5rMaaL2hxuQLGeuo4nCYhaAfULDX
         3Tw1bnk88VoCQOQpOLy+fKleSTIGWWTpTiKhh8H5r0ZBL07Q7cWPG7gpxGRu2EC5WLzI
         DXL/fJnrE0xpQ2PQzPh7p9e1lePC1Pss1oZROxIx9thTcVzt66F+qFH5OvzMyBeAp6wl
         Hjcg==
X-Gm-Message-State: ABuFfohiHfFW4KXpaV+PIiYztdaY1j7JdlPVFScqhFUYvlX+J32ovv/s
        clNMe46hRbmMQEmxN9LvufzhYt66eo0h5clf964=
X-Google-Smtp-Source: ACcGV60mptFHx3YQ66GxJp7PJvxwpcEDhCTLo/Mq7rrjtfKuDyxr7xrHifmLWseacYy6Opb44H16bzGp97wufkAFPq0=
X-Received: by 2002:a81:8604:: with SMTP id w4-v6mr5675581ywf.409.1538722072073;
 Thu, 04 Oct 2018 23:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870034823.29072.4817036324117498634.stgit@magnolia>
In-Reply-To: <153870034823.29072.4817036324117498634.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 09:47:41 +0300
Message-ID: <CAOQ4uxjXt35dUxwrRpVaRf048+edD5RRtHD2aqSOA-2C_=BnEw@mail.gmail.com>
Subject: Re: [PATCH 10/15] vfs: make cloning to source file eof more explicit
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Use the new CLONE_RANGE_EOF flag to explicitly declare that the caller
> wants the clone implementation to set *len appropriately once the files
> are locked.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 7cfff497263b..4eaea52f70a8 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1747,11 +1747,12 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
>
>         isize = i_size_read(inode_in);
>
> -       /* Zero length dedupe exits immediately; reflink goes to EOF. */
> -       if (*len == 0) {
> -               if (is_dedupe || pos_in == isize)
> -                       return 0;
> -               if (pos_in > isize)
> +       /*
> +        * If the caller asked to go all the way to the end of the source file,
> +        * set *len now that we have the file locked.
> +        */
> +       if ((flags & CLONERANGE_EOF) && *len == 0) {
> +               if (pos_in >= isize)
>                         return -EINVAL;

Slight change of behavior with clone of 0 bytes at EOF.
Is that intentional?
Does not change behavior through the entire series?
Please drop a work about this in commit message.

Thanks,
Amir.
