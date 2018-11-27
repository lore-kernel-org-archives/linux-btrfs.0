Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32845C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9B4020645
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQVHnTIp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9B4020645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbeK1HT7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 02:19:59 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:51499 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeK1HT6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 02:19:58 -0500
Received: by mail-it1-f195.google.com with SMTP id x19so654661itl.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 12:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ubcuu9Xg86pQW9E+dvWqbHKptaJoKBWAlQg3MnBI+rU=;
        b=IQVHnTIprRcFvXFPToKGVfMUGb0t9QfwAhjFXrmuN3sGmcJU6aPJv2xipN9zXpR6w6
         vHcrewYVtV2Ny5SgHo9Oz2zv5d+rDSYWW4TdrYSKzxn+QgCYqYu/lR2JBphRI8ah8IP7
         PyvtuS32GER1XGAmZetnZg1jUud3OD2asJ+t2qDkodmVaM/8nnPJ4MS4YytTSEr+T6e5
         xedtfa5pLNDnAcV9G87qnhqhsPWyKd17uHHPccyrJoXbhLuf3NMOny1z69nFAAWGWxl5
         cJOiqW7RBIZetS5bB0Hgy/TQFfLCzkzN9VMyO+bVeyfuX0T/NgSP+kmgUR9E4PH8/S5j
         /Slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ubcuu9Xg86pQW9E+dvWqbHKptaJoKBWAlQg3MnBI+rU=;
        b=s99UYxbuWWT4ACukzy7E2EjlzfgzESdZ0cATlEYbraztXwEP7BBEoleY5APJfjVptp
         BB9l9GB/XTJv1S3lEY2VTqioNQ7eHXzhICXgeddZpO5YtavPMhCRVAXQfjKJpeiXlrXr
         5gE2tN6E/JyTkhLrQ96mpKc1ABYuHOMcM1v4pOUTi4M0l2XRDozljTJBVbDF0Gxjj5iE
         /7CHWhm/Bpme+vHVQPssCd8Qwmi+QfryYgOC9d/X9S+mBqySatjkSN6kSBu7q/cs+YYO
         nXqyNSHzZWpC7CkpqgUe3ePudGt+cLL1V7YFzL8dXvZI2Ad27G3oCqXbmw+ngwDoOjvs
         Q9xQ==
X-Gm-Message-State: AA+aEWYJm4II7PKLBdTdmL9PUGHQjysifSGLmhuF4R+ubcduLH6BxBvk
        WHkk20tM0q+BGqxQyyqBOdDEoHH0LWN6+JDXtss=
X-Google-Smtp-Source: AFSGD/XJKxRmPkVJP1i4MEDx7VQ7aWd9i56qfM7iboHDbLURqrASeMRMdPnCT054oVpvG8F/MHKONOABbO4NJal8OFU=
X-Received: by 2002:a24:53c9:: with SMTP id n192mr382886itb.8.1543350054220;
 Tue, 27 Nov 2018 12:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20181127160010.18123-1-jthumshirn@suse.de> <20181127160010.18123-4-jthumshirn@suse.de>
 <9cc979bd-167f-fd92-1308-ebb1ca85bc99@suse.com> <CADfjVrgC+hd1c_FO_oT5os9H4nacdtq9+a3gXqRmw00sMTmGjQ@mail.gmail.com>
 <6f819719-5b63-c66c-b139-bd415bcca1d2@suse.com>
In-Reply-To: <6f819719-5b63-c66c-b139-bd415bcca1d2@suse.com>
From:   Noah Massey <noah.massey@gmail.com>
Date:   Tue, 27 Nov 2018 15:20:17 -0500
Message-ID: <CADfjVriSO62rnHM39_zbUiCVqEG68gwSP7LBJK_FrJ-e4cNxAg@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: document extent mapping assumptions in checksum
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     jthumshirn@suse.de, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 2:32 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
> On 27.11.18 =D0=B3. 21:08 =D1=87., Noah Massey wrote:
> > On Tue, Nov 27, 2018 at 11:43 AM Nikolay Borisov <nborisov@suse.com> wr=
ote:
> >>
> >> On 27.11.18 =D0=B3. 18:00 =D1=87., Johannes Thumshirn wrote:
> >>> Document why map_private_extent_buffer() cannot return '1' (i.e. the =
map
> >>> spans two pages) for the csum_tree_block() case.
> >>>
> >>> The current algorithm for detecting a page boundary crossing in
> >>> map_private_extent_buffer() will return a '1' *IFF* the product of th=
e
> >>
> >> I think the word product must be replaced with 'sum', since product
> >> implies multiplication :)
> >>
> >
> > doesn't 'sum' imply addition? How about 'output'?
>
> It does and the code indeed sums the value and not multiply them hence
> my suggestion.
>

I'm sorry, I didn't phrase that well.

Since 'sum' already implies addition, it gets confusing with the
mathematical operators used later in the description. So, if a
objective noun is required, a generic term such as 'output' or
'result' reads more cleanly for me. OTOH, dropping that and creating
an actual expression

*IFF* the extent buffer's offset in the page + the offset passed in by
csum_tree_block() + the minimal length passed in by csum_tree_block()
- 1 > PAGE_SIZE.

is also straightforward.
