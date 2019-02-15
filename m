Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24193C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9291206C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GwSA+2Mz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfBOSis (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 13:38:48 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:45012 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfBOSis (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 13:38:48 -0500
Received: by mail-lj1-f177.google.com with SMTP id q128so9163482ljb.11
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 10:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6UJWQVDm7lS/emX04ey42ynTdkHJJgRdYcrFCDfYjg=;
        b=GwSA+2Mzp/HhnylboO6q5ZbWK6nat3GgpfzgMeJnYe2vwMU0/aq8SmlRGqEWxYLb92
         5z7javpVmECsfJ7PJ724n4frgGqKY8AXRth5uLlqCf/lpEvXnaEbHAAUW3JmyBOIX6ei
         InSuvOk6qSt7BrV1QAPBTlOMnUVLzljL6nKj2CPr9Kjfgj9Mf9SJCJidd5wsVwq2JerV
         vVL0IrzVAensa36tGh1UWUSp7HTGce/ZvOL0SkRMaPIu1B//Fx6BP2A+v2k0DcSo01pV
         ceekkQ5KaE8mFFCnjNnb/Vdm8J8naH4xgZ4q2CNwSS3XCYk7s6CcA2iVCRj1flI72XQE
         bN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6UJWQVDm7lS/emX04ey42ynTdkHJJgRdYcrFCDfYjg=;
        b=abuQecSR9sC01WUHbY2tMuyjuUQDqXgaNcaKAe3jQ84jxAb7QmPLoLlVnsREx4cuSL
         vK1Cr51zOgK3zo31QRgHYXtHqQbVdTCNfo2oFb4cYpXyizroZwxRJLzUlXtlecZ+DzvD
         lX6QSZs5hYxgCAtTBWXzEEUjiasgQsdLtZej+G7UPzGLbHZqk9L8shT9ZGFWzglGlPTE
         10HsE+hRD440g57JhzQvFcw17W5nk5DtPHdsmG9AzZIMUS8HotFrxnU5wX+KlQSA1zSQ
         KV5sonHDh8cfREWdCqosM7R1l6L7Ovw7nt+6XBwecYvMKZs6pRpj8PkWyNMdpTJiEjQq
         plJg==
X-Gm-Message-State: AHQUAuYidj2O0XzsH/YBnFINIiYss+1/SfU7uqiDyCX6oyBkF9AD83g3
        0fyOZo26Zpbx/dg/oHmecg0PktxVLYH8ICVoGMnvhnpf
X-Google-Smtp-Source: AHgI3IaOtZ53CtTHiEMSAZUAeD0Wsyye8bkivHDaM7lRcswKmhVyZ+txhOOOuY1vMcwnCfkhtE6ar4eJ2IK4VPgcKrU=
X-Received: by 2002:a2e:3308:: with SMTP id d8-v6mr6313499ljc.38.1550255926095;
 Fri, 15 Feb 2019 10:38:46 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com> <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
In-Reply-To: <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 15 Feb 2019 11:38:34 -0700
Message-ID: <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     Remi Gauvin <remi@georgianit.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 14, 2019 at 9:00 PM Remi Gauvin <remi@georgianit.com> wrote:
>
>
> > It doesn't work this way. The snapshots a and b are not based on the
> > same underlying subvolume. The gist is that you would keep changing A,
> > and take additional snapshots of A, such as a.1 a.2 a.3, and you can
> > do incremental send with 'btrfs send -p a.1 a.2' which describes the
> > difference between those two snapshots of A at their respective
> > moments in time. You could also do 'btrfs send -p a.2 a.3' or even
> > 'btrfs send -p a.1 a.3'
> >
> > But as there's no relationship between
>
> snapshots a and b, I consider
> > it a bug/missing error handling feature, that btrfs send doesn't fail
> > in this case. By using -p you're claiming there is a parent-child
> > relationship between a and b, but there plainly isn't.
>
> They kind of are related though, since the two snapshots reference the
> same data blocks, and you can see it work in the first example with the
> 40MB of random data.

Is it more of a case for clone, -c option? I don't ever use it, and
the man page could use a couple examples to make it more clear what it
can do. And it makes sense this option could be more tolerant, less
error checking, than -p.

But from man page and in particular the wiki, it's clear to me that
the two snapshots following -p option, need to each be derived from
one subvolume. I actually don't like the "parent - child" metaphor
because really the parent is the original source rw subvolume, and its
two children snapshots are the ones used with -p. The first is an
older sibling, the second a younger sibling. And that metaphor fails
too because you'd expect the second sibling to have more information
which plainly is not the case with actual siblings. :P


> The out file is only 773 bytes.  However, if you repeat all those same
> steps, but replace the dd with:
> wget -O A/dir/server.jar
> https://launcher.mojang.com/v1/objects/20c069d373e77265aaeeedb733f7051e294325a3/server.jar
>
> The resulting out file is 34MB.

Well I'd say maybe use -vvv and --no-data instead of -f and see what
it's doing. It sounds like the former has no payload, just difference
information, and the latter has a payload. I don't know why.


--
Chris Murphy
