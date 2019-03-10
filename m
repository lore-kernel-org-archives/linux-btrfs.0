Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFD3C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B842D20652
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 23:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="CeMaiV5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfCJXUe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 19:20:34 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:38972 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfCJXUe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 19:20:34 -0400
Received: by mail-lf1-f49.google.com with SMTP id m13so2022788lfb.6
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 16:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=04wa2SasSoy5Qo4n7kmhJQtsiwblmZFaP3YUL7jRP14=;
        b=CeMaiV5laROZwae8QTeQQYFz+vuaST73ezc4GaDYRqN9NOPdKt1JPLwUZ+WKYOvwhP
         WoxZTF5F2YoLfLAbwisSplm+7NcqZ9NigO55Bzz5/XJT9S/4qU/cY1DIqgHDKc6LyEPs
         yETqvsScFETtiaHxyBtpCS9Ot0a93QtcFYuOzya+PMRdUPPQy3UIC89Q0ICH/2w0UVda
         JQs5dbHunzNWScU4qg4RzuBh3I6hE2rZhkX+BKXfDsjfIDXO21WPpB4JflAjnsrghfrY
         hxgbTHtYxuDr+dpXo8zZnKMoouCrulBnEqxgmtuPr7LoCvUkQ9/4pxmTQjR0aHLzm1yZ
         CnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=04wa2SasSoy5Qo4n7kmhJQtsiwblmZFaP3YUL7jRP14=;
        b=l2tjuAXpxLSgE188PaXOq8ztzDxp7ujN08brid1oLZ+ZXxbYe0SnYBcgueXAd+i6u5
         yr3LWGMiu3waayzPWpseW0X02N85+mmTJlYkHkRKGl09dfSerm/hX2D9bajPBhRlU0ZZ
         U9fKbJ3ZyF8VJIGqvdphhoqODLkJg8XbuNCZq5FCI5xG1IjM4Vqa/UnrMdrlG3msj0oO
         scriT9Qp7LqSR9EEg3Ap6RjFEH2dcqVbhL5goefJSut7i0nl2GEvWBtMmwF2QDpfy5o6
         6t4G3kqCpjhcmOIekNcHLMLnFceHcctd4J2IwTAvjdiNDJJ/+824U616kKOhYD49XSsA
         r/Ig==
X-Gm-Message-State: APjAAAWjMmYh1C3Llp8KLuh2Np4vdj9HoZHaFoEle5oyM0Jws/ymKReD
        tVSx1ORVe3r5T/Usw3kxdhyXABruBkOi9S46/R2GcuKe3dI=
X-Google-Smtp-Source: APXvYqx1PZiyXm7AzB1RMi9dn4PCSvrAAmDbEhQxBMeFviuJk978mXfH174DGjHTPMQaQs+YWNv4KgcfBHX374hrVRk=
X-Received: by 2002:a19:a1cc:: with SMTP id k195mr7506765lfe.65.1552260032036;
 Sun, 10 Mar 2019 16:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com> <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
 <afe23216-7d73-4d33-d80c-15d29f24c64f@gmx.com> <CAJCQCtRyStqPLOXHVWkcha3GkA7wt2u00qSH7DfUyL_ift5ppQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRyStqPLOXHVWkcha3GkA7wt2u00qSH7DfUyL_ift5ppQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Mar 2019 17:20:20 -0600
Message-ID: <CAJCQCtQ7aFpyQ+g_YWZJCuwuqOSXH-Gany9s-CgEQM6f2RK5bA@mail.gmail.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 2, 2019 at 11:18 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> Sending URL for dump-tree output offlist. Conversation should still be on-list.


Any more information required from me at this point?


-- 
Chris Murphy
