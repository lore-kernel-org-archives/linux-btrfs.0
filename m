Return-Path: <SRS0=p/S3=UN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2580AC31E45
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Jun 2019 00:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBB8E21537
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Jun 2019 00:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihmuxf6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfFNAS5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Jun 2019 20:18:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42248 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNAS4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jun 2019 20:18:56 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so1890756ior.9
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2019 17:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wYo4W+YtXHA/AJ6GJUShBvb4pm+fzTZgR20rmgEVgCw=;
        b=ihmuxf6kCwqHd78L8S+BCA50Zd2PHkJqoQwSZmEaY30zpvNbnSsvwdPF7kI8doqqYh
         dKvhvGhczenAbd3F2W02G+13e2JnKTPk9kEGMW8AL24MGQu85NgJetP5SIlgkRt0q6RO
         z9uzblQDGVB/ywgKkDf6fPKY/lUBQNfqSmg38GUSW4gvh7UYWQC+6cstzbpy1qMT0M8F
         vXLx/QnSWssa5mSB/p88TQ+NYiJjIu/r3TH9r8eCrTLmfYxUYELpQorSyxrMo1liVB7E
         yZDvsxPHW0UkpnXDPRiPfw3LFpltBI3lapuxk7S4twVXdYGpYLJHlY9XVIvWfjNdVOOK
         lyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wYo4W+YtXHA/AJ6GJUShBvb4pm+fzTZgR20rmgEVgCw=;
        b=UtLeAQJhZag6aFmT93JPCt8vAXrGsixELP8OdeDnwFKL3kFYV9jCs4WRlCi5ePpXUZ
         oXVE3WfNROmLZigeSi/2VFZi1Jc+EOtDMJmQzFl3taso9RI2aFTRCiqIPN1Ekq8Q82vD
         M509Jv6WWQqvctuNBVw3lmhpk7/bQd+/EXzg4qEBPq8Mfeo2Z3QVvi+OsW/pnwnnB9ft
         YjfYj9bMGWAEENVexfgoojIi5FeuXlpAdyr2368276FFqc631Z8qoWr4ETsnXurdcOty
         rMdSh/T4qhqobFvucz/UmCKj9c4toz30qCkyI2rD2xRWu/HCPOn1zTVBvCYSWThdxtzx
         vyNQ==
X-Gm-Message-State: APjAAAX+pg+Ve++7vFZMj9YG/va+Km74h+a5JbWL80ruMvcvlMdUH1yr
        UlBsLZjd3jabL+83WpEImVcbENXa8LCyzAlf6cg8+w==
X-Google-Smtp-Source: APXvYqyixdS9LUaa10jxll4ldDTQL3VzBDFJkzZV66Y1KSGkInIDDmRYSRPN62DFwy2Gqaxo6+Ebky/PwNZnS8pT3m0=
X-Received: by 2002:a02:a90a:: with SMTP id n10mr48649801jam.61.1560471535800;
 Thu, 13 Jun 2019 17:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_8rEfMr-MpQ4bfBs79aJybBE3ipOwN=yQDBM6W+bWprFz34g@mail.gmail.com>
 <51a231b3-7f04-bcad-a3d9-3bec791850a7@gmx.com> <CAG_8rEcn7JYTf6S24wBEQbFDs5yz_uUr9gUMSSmLmgs4j4gheQ@mail.gmail.com>
In-Reply-To: <CAG_8rEcn7JYTf6S24wBEQbFDs5yz_uUr9gUMSSmLmgs4j4gheQ@mail.gmail.com>
From:   Steven Fosdick <stevenfosdick@gmail.com>
Date:   Fri, 14 Jun 2019 01:18:44 +0100
Message-ID: <CAG_8rEeAWQL1U8EM1e4w6SOdHx0_BVR_7JGLN9fp7-nsn4oDhQ@mail.gmail.com>
Subject: Fwd: Removing a failed device - stuck in a loop or normal?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 14 Jun 2019 at 00:41, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> That's common if the device is really failing.
> Raid5 should re-build the corrupted blocks.

That's strange then, because there are a few files that are
unreadable, i.e. attempting to read them with normal programs like
'cp' gives I/O error.

> Looks like a dead loop.
>
> Would you please provide the kernel version please?

Linux meije 5.1.9-arch1-1-ARCH #1 SMP PREEMPT

> And have you tried cancel current balance and start a new one again?

How do I cancel it?  I started "btrfs device remove missing /data"
with nohup.  That ssh session is no longer active and issuing SIGTERM
to that process doesn't cause it to die, which is not surprising since
looking at the source it seems to execute the whole device remove from
within the kernel during a single ioctl call.

Thanks for such a quick response, too.
