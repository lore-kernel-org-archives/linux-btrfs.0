Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD961C6787C
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 12:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D84D20652
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 12:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ceremcem-net.20150623.gappssmtp.com header.i=@ceremcem-net.20150623.gappssmtp.com header.b="tgJBYtsD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D84D20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ceremcem.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbeJNUBJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 16:01:09 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:40312 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeJNUBJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 16:01:09 -0400
Received: by mail-vs1-f52.google.com with SMTP id f65-v6so479822vsd.7
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2018 05:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ceremcem-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BPVABFAP8ITejTgq4h62nV9H1HlROom+MVkeCHwuqQE=;
        b=tgJBYtsDSV7R+ZZDuj0lny+LCg8cxXa0W6dwZUzCMVXNUaJRNyjIWIDVfQSyTPa3N7
         gQJLL1sN8kyFdYFxHQYFMo4BTPVrU9fg+YROq4lEEeMilCOwpFDjGgza2wXNE91LOyy9
         Cz8ZZ/0A7NwjWMiyBkRiXQ/4DzomfHuiMx/a6wWsMFjwemHDWrkomQagQszwUjyxd8OY
         A73tnmFGIKKIollk5JQCNBVtyReYNJ9Sa33jnsFTG2d3vHhj08QTHtKMV8EfHeQQZYKx
         hG/JJzH+hEsUhjZRYeE5tc+NHNoZ6+S2QBBvbs/LDjeokfOFEV4nx3aPqtdfwO7kHuei
         rH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BPVABFAP8ITejTgq4h62nV9H1HlROom+MVkeCHwuqQE=;
        b=phsyf57d7MdPzyJ6hAS0KOfJZoxPPUd8PLdOhjGHlzkW5kKT/9gQvoAU4CfRUCeP2+
         B5GcRGPsikgOpfQugDWqPO2SBUGXoSwEmJi79st1ICC0fVpjHqi1KH/jrVEnAZ7QFh9t
         cmKN0y5I8hhYT5pnustZZSMy7OMFKh3olS1DuOO30RQSVOyoxYdeeTRcRZsh1dv8Iaxj
         UK2bfS3MyRmwP9dGK4qAOYVQKEgWB9WgkCA2AN5XhXIcFaG2/Yid8dIRI6CHDV3ee2xf
         ZTopi4ga1StaCEheo2F6InCvhep21SLlwyVxI+jjdexiwYnT6lTmdccX9/5Ao7/01tGd
         rziw==
X-Gm-Message-State: ABuFfoiaolVzFpz8sIWDWyAV8SHC1cTEDt/SjY7yZ7gkOA4A1xUl/AND
        kp7HFbb74ViuRgjwFeMl99GOhSDRV1yZ5j31XpWdbQ==
X-Google-Smtp-Source: ACcGV61CSfvJraOeMC51OSlSKyqg62EgIgjoVk6uefj0JSXrBoyNlUjU9KR8Anin0je8x7smlvs9Hij17cgJCeDID00=
X-Received: by 2002:a67:8158:: with SMTP id c85mr5164643vsd.129.1539519618866;
 Sun, 14 Oct 2018 05:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com>
In-Reply-To: <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com>
From:   Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date:   Sun, 14 Oct 2018 15:20:07 +0300
Message-ID: <CAN4oSBevO04cV+DyGxXg60nBbYB7UANFZzMcWV1M0S6HpHYc-w@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>, anand.jain@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm not sure I could fully understand the desired achievement but it
sounds like (or this would be an example of selective perception) it's
somehow related with "creating reproducible snapshots"
(https://unix.stackexchange.com/q/462451/65781), no?
Chris Murphy <lists@colorremedies.com>, 14 Eki 2018 Paz, 02:05
tarihinde =C5=9Funu yazd=C4=B1:
>
> On Sat, Oct 13, 2018 at 4:28 PM, Chris Murphy <lists@colorremedies.com> w=
rote:
> > Is it practical and desirable to make Btrfs based OS installation
> > images reproducible? Or is Btrfs simply too complex and
> > non-deterministic? [1]
> >
> > The main three problems with Btrfs right now for reproducibility are:
> > a. many objects have uuids other than the volume uuid; and mkfs only
> > lets us set the volume uuid
> > b. atime, ctime, mtime, otime; and no way to make them all the same
> > c. non-deterministic allocation of file extents, compression, inode
> > assignment, logical and physical address allocation
>
> d. generation, just pick a consistent default because the entire image
> is made with mkfs and then never rw mounted so it's not a problem
>
> > - Possibly disallow subvolumes and snapshots
>
> There's no actual mechanism to do either of these with mkfs, so it's
> not a problem. And if a sprout is created, it's fine for newly created
> subvolumes to follow the usual behavior of having unique UUID and
> incrementing generation. Thing is, the sprout will inherit the seeds
> preset chunk uuid, which while it shouldn't cause a problem is a kind
> of violation of uuid uniqueness; but ultimately I'm not sure how big
> of a problem it is for such uuids to spread.
>
>
>
> --
> Chris Murphy
