Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7B7C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 16:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB7221903
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 16:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ntYr4jyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfDAQnz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 12:43:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39669 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfDAQny (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 12:43:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id l7so8806693ljg.6
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2019 09:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HqPJkWZVy+H0m1b3KYUjAA4KG4xZSj6XihKHq6Ikgjk=;
        b=ntYr4jyh4z3K5bn0DRzTmmU6nqxBK0YUv5gdCxFFIjguqvIGY0QgoiqOLpO/g+JFLu
         MqRzkE0C4qdPIQWGHQMDHas7mVmWuKA8QdhHrV0bb9vHqQaU8rPjuQlcRqAlTVEmZ6Nw
         bRng3e/ikh99DvBZgewuUvEhUUh+pBWutPNXtkEf5h8s7ATlNxxxX3hwYWXybJmlwpn7
         6b51cxB11/kdI3IFHJjq0Rc+9l96JNjQvSuF+T57axhbNjT7S8zmztobNa2fo9U3GwvG
         9wxB2b5vkAdEtYYOH4BTrNuFURdJ7i1uUeMlefpGat+tVjhvvfByYcP3Ec5gaU7PCGHl
         Jlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HqPJkWZVy+H0m1b3KYUjAA4KG4xZSj6XihKHq6Ikgjk=;
        b=STdC9Geq1WamPH+3B81geQMbF8ja96nrxAjGIt9YNbcyiXRcCh/FnQpk5ykV3XSzc4
         RrjpQ4Vqut5yEsrgyK9BMB7vymLelus86A5FMqbCuoEf+jj3Rq86jGS7tcgXDW1qCJfn
         UXEZXYf2Wvz3jdJcNXnbDNls+LVj2O+T0pxRPDBzWfrjRcmx98kh6xYjLQ00KNi4qnv4
         Ppn0mhhtVSlRzyLYki2O5pJmjJ991iKtu+nmKEzezhtqot6FwvdDI3JBBoemsS7FbIKW
         qJmGk4P5imoOAZ0VB/dgAKwoMnkvPqfkkNMk7/iPHNuV0PN+u322bwLmwU+yh9e2gQhH
         qh7g==
X-Gm-Message-State: APjAAAXr8xg3mGQx60+o1QFoPKBynG8ha6YIUMNYIaEpouyuTfqoKKR3
        SPLRaWSDsu2KRUZZNsyU/VL2zaibt9iph9qeQynjYRnKqPE=
X-Google-Smtp-Source: APXvYqy4xek3ZFFNAYQ+ShkpBvIUusbNOYdP8mAJ5042LUKu5pEJg395KKhuZUkpuQ87HwZ3V0G92qZYToHRmzlUbQk=
X-Received: by 2002:a2e:8316:: with SMTP id a22mr35608938ljh.171.1554137032806;
 Mon, 01 Apr 2019 09:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
In-Reply-To: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 1 Apr 2019 10:43:41 -0600
Message-ID: <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com>
Subject: Re: btrfs balance hangs
To:     Zirconium Hacker <jared.e.vb@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 1, 2019 at 10:12 AM Zirconium Hacker <jared.e.vb@gmail.com> wrote:
>
> Hi,
>
> I recently started a balance on a BTRFS filesystem.
> At least one process failed to write files before or during the
> balance due to a supposed out-of-space condition.
> Yes, I know it's not good to allow that to happen.
>
> Here is the relevant dmesg output:
> [694828.101677] BTRFS info (device sdh1): balance: start -dusage=60
> [694828.103543] BTRFS info (device sdh1): relocating block group
> 2933242462208 flags data
> [694883.648385] BTRFS info (device sdh1): found 76 extents
>
> At that point, disk I/O according to iotop dropped to almost zero.
> After waiting a while, I attempted to cancel the balance, but that
> just resulted in a hung cancel process.
>
> Now, any process that attempts to write to or read from the filesystem hangs.
> I suppose that means there's a kernel deadlock.
> The output of dmesg after running echo w >/proc/sysrq-trigger is attached.
>
> kernel: 5.0.3-arch1-1-ARCH x86_64
> btrfs-progs version: v4.20.2
>

Are qgroups enabled?


-- 
Chris Murphy
