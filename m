Return-Path: <SRS0=bWPQ=XM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D19C4CEC9
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Sep 2019 18:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A992053B
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Sep 2019 18:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SF/0rk1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfIQScC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 14:32:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35529 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfIQScC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Sep 2019 14:32:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so4267183wrt.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2019 11:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WkXQL4GyvDNf/lDw0pXPxwN8EXbGCsbQagXm0hsy5Mg=;
        b=SF/0rk1MFGUNCnQYcKEKhoEbuFNVXm0QWHSaMfV0TYb71CqTIT1TGVlsEabCpcsPAT
         MhzmWvmAktEzg4eJJwns2d3SES+Zk2wz/W9GaokWGawBLKKjiD/lrpuIo8Rjirx8Kwsb
         CUK/gRQREOovbxMfH86k3p6OIqefRphgx8USdZgTL8lT8EElUIg/OA00x6Qg0psjQ4T5
         m3KUAbxEnQZ+GFjOG3lOHdoFwW8CrwGf0i7xLCo2R7JmBWyMDj2ZkWySt6k/vVUn/yJO
         ZAys/IidVD3e3XONBAs5Ujzi+BWTPTV9/Ap8nGgNBa23kp6hJpTT7cu4qZaWISjtlO6l
         /yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WkXQL4GyvDNf/lDw0pXPxwN8EXbGCsbQagXm0hsy5Mg=;
        b=ZWSsyHkpn4UuAr+Y9UsjhjLLVyoZYVlLlRujXYwcIarMh6RJiXT0lxYdFaqcDb3mdF
         yhobxAbFBLk8cDwG3EKnNj0L31B0GXqEJajq+IT8WBrcqd3BoxKHZaY7JB5pNVEdVZ6b
         eE/EqQyw30t0UrLF0UAg4KtAQAFW53y8oq8Aes/TjbB9+o9km34jVzud7u/KgmIsAgC7
         wgK9h7bJzokuaBFKeKOoXjzNeY2vh+57QGG0c6VRd6gwdFXeh2/HEo8asT1o6hn8UCew
         FzAKxIjX/9aUTYMPhTRzMP7Y7dEo+mCnwI9d0zlKLxxHfFQHOHh8YdqVp77lRtNmJGbb
         wK2w==
X-Gm-Message-State: APjAAAXduqtq9Y0tWH+86hInx9BqlJGH4cnEoLEf85OnbBlM56osjCNX
        REQUFEDO0IGy/0DadHw7XRPqsM8DCdhbukuAd4Y=
X-Google-Smtp-Source: APXvYqyHJU2q6h5yj9fk702989h3kVcEQ7Jzltj6JzN0jQKZOlcV60d6kFntDOyiSoytmhPhzha0PJLLLhLRQO6azRY=
X-Received: by 2002:adf:ed05:: with SMTP id a5mr24673wro.35.1568745120172;
 Tue, 17 Sep 2019 11:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <591580482.537773.1568655046847.JavaMail.zimbra@robco.com>
 <79984309.572916.1568665920098.JavaMail.zimbra@robco.com> <289cd208-49cf-8194-d4df-5d0423b6b73d@gmx.com>
In-Reply-To: <289cd208-49cf-8194-d4df-5d0423b6b73d@gmx.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Tue, 17 Sep 2019 20:31:48 +0200
Message-ID: <CAA7pwKOF+DayHi+gRHusMzJ11_0aQtw88PWugzZJY_yU5uOJZA@mail.gmail.com>
Subject: Re: btrfs scrub resulting in readonly filesystem
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Lai Wei-Hwa <whlai@robco.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 17 Sep 2019 at 10:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2019/9/17 =E4=B8=8A=E5=8D=884:32, Lai Wei-Hwa wrote:
> > [ +0.000019] CPU: 18 PID: 28882 Comm: btrfs Tainted: P IO 4.4.0-157-gen=
eric #185-Ubuntu
>
> Although your old kernel is not causing the problem of this case, it's
> still recommended to upgrade to a newer kernel for btrfs usage.

https://wiki.ubuntu.com/Kernel/LTSEnablementStack
