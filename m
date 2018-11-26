Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A564FC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 08:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69C112082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 08:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OPgJf0II"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69C112082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbeKZTKv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 14:10:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42964 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbeKZTKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 14:10:50 -0500
Received: by mail-lj1-f194.google.com with SMTP id l15-v6so15677134lja.9;
        Mon, 26 Nov 2018 00:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DL1JU2Jl6dHmu7oOgaXiyAFBJJhQbFK6TWDQpuzmsr4=;
        b=OPgJf0IIpylcteRNfDc3IqVd95zj+0p2O6hBuUB8D3uwtsDz/KrvNzhOvR4cw8fSmf
         1HHWDwFzsaAENxmFNKK+e1RhvMAuhAgf1/p0uCXIqEx6JdoL2JWxl8tnHgisByCyB7DX
         hBzdAxtbDHUlcUwnJONnm2ifPBzoVGfPDq/78lxTtTfRbtfiAM/Vd/sfmtPhIdgY8I+o
         2tWwwVA9NJ/gP2AndTm/NReUOhg510NEzWNKvTJSNCjMkbd7euf2L8TdUZTurfktp5xq
         qP+/pxlBBYTWaixtzzGVUHeg0TAIOOo8PrD2tJiyB7hq3gyeiBdYxn4uhZczS179gF19
         vf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DL1JU2Jl6dHmu7oOgaXiyAFBJJhQbFK6TWDQpuzmsr4=;
        b=F/uThOZyatIp0yHmlZb0JjM1HBZ0JxhuYJ3j60HsqhetcMLXmOLlhiGUNOMF8EJYFU
         X/AdyN5KWGt9NESLY6tTKIhK0ko+5SCgwU1tRPXBJOKpTuHeMzoTu/h20KO7sbE0kMBP
         RPvDwnNC+qF8BE1h32TUPFt1niBflNsyS7RWU55J5i4T7FL5242rAi8LpKAYv6Gq9ry5
         6p7plxFRl0Mt5NAqHBfs2QadPVweE+0uaVxnmx+gT21/xr/2TrqT+4QbhQLDugBAaxJh
         I5/MwcTz6QaInR8IkxGjoymnvJ7ZWOgiB2SR2rFphoQOVz3ExaLzrfx4+Un5CoeRDmDJ
         c1cg==
X-Gm-Message-State: AA+aEWauZe+U1RlUyz8pFmXz08Z6Ybl6khQvyMEy2SgYBqQ5lSkzBFH7
        BqTVynFMafxotetlqOjucnCDv39ug4fB7fPtcz4=
X-Google-Smtp-Source: AFSGD/VTOt2bq0cxRq6Vx5uu/66ncyC731ADEI57OU28qOq5jRn5s9MSl77HgATKVmyT1/PlGeH5BLIRNlUyr8UuEas=
X-Received: by 2002:a2e:5054:: with SMTP id v20-v6mr15822680ljd.45.1543220247340;
 Mon, 26 Nov 2018 00:17:27 -0800 (PST)
MIME-Version: 1.0
References: <20181126021720.19471-1-ming.lei@redhat.com> <20181126021720.19471-7-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-7-ming.lei@redhat.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 26 Nov 2018 09:17:16 +0100
Message-ID: <CANiq72nSa-=n2WUvmQOieDRtf+gC1wg2YuRvKDniSAtDn8=U8g@mail.gmail.com>
Subject: Re: [PATCH V12 06/20] block: rename bvec helpers
To:     ming.lei@redhat.com
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, "Ted Ts'o" <tytso@mit.edu>,
        osandov@fb.com, sagi@grimberg.me, dchinner@redhat.com,
        kent.overstreet@gmail.com, snitzer@redhat.com, dm-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, shli@kernel.org,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        gaoxiang25@huawei.com, hch@lst.de,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        colyli@suse.de, linux-bcache@vger.kernel.org, ooo@electrozaur.com,
        rpeterso@redhat.com, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 3:20 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> We will support multi-page bvec soon, and have to deal with
> single-page vs multi-page bvec. This patch follows Christoph's
> suggestion to rename all the following helpers:
>
>         for_each_bvec
>         bvec_iter_bvec
>         bvec_iter_len
>         bvec_iter_page
>         bvec_iter_offset
>
> into:
>         for_each_segment
>         segment_iter_bvec
>         segment_iter_len
>         segment_iter_page
>         segment_iter_offset
>
> so that these helpers named with 'segment' only deal with single-page
> bvec, or called segment. We will introduce helpers named with 'bvec'
> for multi-page bvec.
>
> bvec_iter_advance() isn't renamed becasue this helper is always operated
> on real bvec even though multi-page bvec is supported.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  .clang-format                  |  2 +-

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
