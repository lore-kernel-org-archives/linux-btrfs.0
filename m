Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f42.google.com ([209.85.167.42]:35047 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeITOrc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 10:47:32 -0400
Received: by mail-lf1-f42.google.com with SMTP id x20-v6so7653576lfg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 02:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20180918153348.7723-1-timofey.titovets@synesis.ru>
In-Reply-To: <20180918153348.7723-1-timofey.titovets@synesis.ru>
From: Peter Becker <floyd.net@gmail.com>
Date: Thu, 20 Sep 2018 11:04:52 +0200
Message-ID: <CAEtw4r1UaR1ydbF-YNbiifhTtJ8M2kK=xpV0QYFMTjZcn=Nydw@mail.gmail.com>
Subject: Re: [PATCH V5 RESEND] Btrfs: enchanse raid1/10 balance heuristic
To: timofey.titovets@synesis.ru
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, nefelim4ag@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i like the idea.
do you have any benchmarks for this change?

the general logic looks good for me.
