Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33268 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbdEVH5k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 03:57:40 -0400
Received: by mail-ua0-f172.google.com with SMTP id e28so54335783uah.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 00:57:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f0ed81f8-a312-72b0-5da1-56cfbc1fa81e@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
 <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com> <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
 <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com> <CAKuJGC_LWzJKGPecweK93nXRm1=j22HkqZdUHrragwab6zAUDw@mail.gmail.com>
 <f0ed81f8-a312-72b0-5da1-56cfbc1fa81e@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 22 May 2017 13:27:38 +0530
Message-ID: <CAKuJGC9YY-1i-Hxq7=8E_pd19xOA7Tt0ckYEpwJhrgtSbardOA@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> As the title said, it's *offline* scrub, while you're still using the
> *online* scrub.
>
> To use offline scrub, you should exec "btrfs scrub start --offline
> <your_device>"
>
> And then it should detect the same error.
> Output is nothing like kernel.
>
> Thanks,
> Qu
>

Ah,my bad.  I thought the entire binary is changed, didn't realize its
an option.  Will check again with 'offline' option.

-- 
----
Cheers,
Lakshmipathi.G
