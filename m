Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4AFC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F037E20652
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="UhnMGfOa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfCJXSv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 19:18:51 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:45663 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfCJXSu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 19:18:50 -0400
Received: by mail-lj1-f181.google.com with SMTP id d24so2387061ljc.12
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Roy7wYuJ234UH+EfiWMcSaiJsuaPlGPy0SYvtWtm0Jw=;
        b=UhnMGfOaG5MgP+iTeJ6GipizH4rNTUVFH+NSAf96PmlyUD/5znUGs1hH0H9R067TKf
         aqJGtJCHmTjsZRsBUaSskgQvaskoxmZyKdNchLxd2L6m5jGdNllFBlQyLmeqf4sz6DA+
         bQnA71ZMnMznOmVsf6/u/YskS7QdnnQiwWNy//RhpbSSpCMCcl0wX3z0yQ1LJ5SoulDg
         CvcAwCMVbGC1KCKPb7bcpZZffSCsRlXeJmrBDjZAH7nTVsyv4hv2yXHHFsvX6TRUg2Nh
         iC4uWi0k7ucx4RDMO3XFsjh/ARChn51KjdytlSZ5rws/8dIZF0gyGu3rrVKMRAIvn/P7
         I6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Roy7wYuJ234UH+EfiWMcSaiJsuaPlGPy0SYvtWtm0Jw=;
        b=QagE1xvD8L38zs4CuvssoUwg0/5PJJswQY+pDFkc1IyrP3VdlShezeLj8+x55q0y1g
         B2NXwNo0Vm6Qx1AHuaFLVpYLn2g/56E5dqzUrONYznb2gIqovmajR9YUDstN+A28iXxe
         hR3bIE4FxcIXvUDILsd6nAPMsmV9lrmsC9r5Uf87JdfcbwXiGiu3/OhRtboJMP6s4VPO
         5fk5lB7zm0kLZOB+HgB56k/bIOZ0KehedyDjVmzTQjdL73vFCJsDeY/1x8D9e9nY4WlZ
         XSLdwWgZ8rkRrHNPSXKstwV1nIJp8hPywRyCXzp1ZHdEaDCfRWy+2SiWyc3AmCNPZjw9
         Gn4g==
X-Gm-Message-State: APjAAAX8c6AKJCae7x0IVSefXQS7cHv0+LWGiBxeKXIsGG3V1mWpMLg4
        jA999Zwk0k2OfJ9L9HIImv0iZEUHvdGcqvFaET8Tck289mg=
X-Google-Smtp-Source: APXvYqw+IrjEVWj0i66RiUREGHBCGKvCRikLq6a9S0cT/8JkZ05JIpfGoLtzMN1GdnJYWfOdb+ZRNiVbAX5f6qFbUMQ=
X-Received: by 2002:a2e:9a95:: with SMTP id p21mr13958669lji.127.1552259928239;
 Sun, 10 Mar 2019 16:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
In-Reply-To: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Mar 2019 17:18:37 -0600
Message-ID: <CAJCQCtSWmqtD-h_XTa9s3xej0m5ggdHJPXZiv9tYDQopzAW=yA@mail.gmail.com>
Subject: Re: confusing behavior when supers mismatch
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Described behavior observed with:
btrfs-progs 4.20.2
kernel 4.20.12

On Sun, Mar 10, 2019 at 5:09 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> In the case where superblock 0 at 65536 is valid but stale (older than
> the others):
>
> 1. btrfs check doesn't complain, the stale super is used for the check
> 2. when mounting, super 0 is used, no complaints at mount time, fairly
> quickly the newer supers are overwritten
>
> Is this expected? In particular, in lieu of `btrfs rescue super`
> behavior which considers super 0 a bad super, and offers to fix it
> from the newer ones, and when I answer y, it replaces super 0 with
> newer information from the other supers.
>
> I think the `btrfs rescue` behavior is correct. I would expect that
> all the supers are read at mount time, and if there's discrepancy that
> either there's code to suspiciously sanity check the latest roots in
> the newest super, or it flat out fails to mount. Mounting based on
> stale super data seems risky doesn't it?
>
> --
> Chris Murphy



-- 
Chris Murphy
