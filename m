Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_SBL,
	URIBL_SBL_A autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A053C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5612220811
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 15:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ky1vfAHn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfCNPJI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:09:08 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:34166 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbfCNPJH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 11:09:07 -0400
Received: by mail-io1-f48.google.com with SMTP id n11so5529305ioh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 08:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=comeQOIDisspzT5H2vQJThEG0mxo/2LAR+73m5EV9uM=;
        b=Ky1vfAHnLhbJNsXOwdMoyV24jQAQA7ooqfeCj+aJBAt/FUQY0Vvxyd8qcsnV1JWZ5m
         RaBsmP/8omNEFi2/EzIwzsI/xUJixhvlNyA0QllPlMUshYjnPEsuKuGwHlYZvPiN9Kv4
         k0yK8aVQ79GEdWJkSeBaNnTn4bgKz0N1unFNhbuLlH2Ny/w0H+UGg1WPwRhvmup9x1Ec
         B61cX/ysxpKZrZOJu3TZO1j8fHpDd2HiTPY+CUl4DYXttCNHidMggp0FYaYamH//ZRk+
         zUqSgibyGLoiA4m9cwfX2Z4eJleruyhW4cFPS28fm8vdTh50v1JCEFVRnQECYJ27X2Zv
         TXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=comeQOIDisspzT5H2vQJThEG0mxo/2LAR+73m5EV9uM=;
        b=ImIVkNr0lW2+N9A9vdYvEksml+37n8gdjUj3MQYlbK4vxs1iPZ2Xchppq0FdIfMePu
         lBq03WlB4nq1pLezTJQBp9oqZIMNAIoaruPP+pqvVvsfY6rGCOmw0YE7aV0qHsD2CuPg
         WkBmmn98/S1NMQM8iqFqQq7qOcUX5g7nz4MLAUsX1R1ZGKFS2bGg6xeXvBiubasOQx0z
         wcqM2/q5jhyyaXlbUWfnIn4aQYmUM+JxqIjpvjZf0pE0lZA01T8KNz+8cTaFEVL21XWc
         h/CcatAd4qNkjGTWeAjmxvFgDD7TPvxgQpKUBRfyz1GJCoTRav49YwWxUwuNc+7MKe/0
         cwgw==
X-Gm-Message-State: APjAAAW6K7B++IcgIkmjkhGWQsZda9rccuyvRavwIp13sWaGa5j9snmH
        NYLfFq/zuMrEz018s+t+inUIZVjJZedBARofvETOGA==
X-Google-Smtp-Source: APXvYqwjSuoOj3KW3n90AHXPrtYK5UMJX8+O3YaT4nJRN9NTtPccVx5FRWhZr97tqSV6L8fT5+Z9RqFhOJ4SCJvCkiQ=
X-Received: by 2002:a5d:8c98:: with SMTP id g24mr28030751ion.103.1552576146736;
 Thu, 14 Mar 2019 08:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro> <CADfjVrjFOMT9FG3t572vtCZzvRaia1d593fyNBMh2zV=FM12UA@mail.gmail.com>
In-Reply-To: <CADfjVrjFOMT9FG3t572vtCZzvRaia1d593fyNBMh2zV=FM12UA@mail.gmail.com>
From:   Noah Massey <noah.massey@gmail.com>
Date:   Thu, 14 Mar 2019 11:08:30 -0400
Message-ID: <CADfjVrihLGaBY_40G0kXbasofnMSrSgoW2FgcGA_p=OKCSr+FQ@mail.gmail.com>
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     =?UTF-8?B?SmFrdWIgSHVzw6Fr?= <jakub@husak.pro>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 10:59 AM Noah Massey <noah.massey@gmail.com> wrote:
>
> On Wed, Mar 13, 2019 at 6:13 PM Jakub Hus=C3=A1k <jakub@husak.pro> wrote:
> >
> > Sorry, fighting with this technology called "email" :)
> >
> >
> > Hopefully better wrapped outputs:
> >
> > On 13. 03. 19 22:58, Jakub Hus=C3=A1k wrote:
> >
> >
> > > Hi,
> > >
> > > I added another disk to my 3-disk raid5 and ran a balance command.
> > > After few hours I looked to output of `fi usage` to see that no data
> > > are being used on the new disk. I got the same result even when
> > > balancing my raid5 data or metadata.
> > >
>
> Am I correct in rephrasing your issue into "balancing 3 copy raid5
> does not rebalance into 4 copy raid5"? Because that was a surprising
> result to me, but may be a spec that I wasn't aware of.
>

Maybe it's because the new disk does not have any RAID5 block groups?
To test, I'd usually suggest adding bogus data until something got
pushed to sdd, then try a balance and remove the temp data. In your
case, it might be hard since all 3 disks have a similar amount of
unused data.
What happens if you 'dev remove' one of the old drives, and then add it bac=
k in?

In case it's not clear, I'm throwing spaghetti here. Have backups.
