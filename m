Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35287 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932927AbcKGR7F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 12:59:05 -0500
Received: by mail-lf0-f45.google.com with SMTP id b14so120198261lfg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Nov 2016 09:59:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
From: Mark Fasheh <mfasheh@versity.com>
Date: Mon, 7 Nov 2016 11:59:02 -0600
Message-ID: <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
Subject: Re: Announcing btrfs-dedupe
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi James,

Re the following text on your project page:

"IMPORTANT CAVEAT — I have read that there are race and/or error
conditions which can cause filesystem corruption in the kernel
implementation of the deduplication ioctl."

Can you expound on that? I'm not aware of any bugs right now but if
there is any it'd absolutely be worth having that info on the btrfs
list.

Thanks,
    --Mark


On Sun, Nov 6, 2016 at 7:30 AM, James Pharaoh
<james@wellbehavedsoftware.com> wrote:
> Hi all,
>
> I'm pleased to announce my btrfs deduplication utility, written in Rust.
> This operates on whole files, is fast, and I believe complements the
> existing utilities (duperemove, bedup), which exist currently.
>
> Please visit the homepage for more information:
>
> http://btrfs-dedupe.com
>
> James Pharaoh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
