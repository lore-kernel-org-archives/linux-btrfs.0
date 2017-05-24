Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35436 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938030AbdEXD7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 23:59:01 -0400
Received: by mail-ua0-f171.google.com with SMTP id y4so83605762uay.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 20:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cfdab92f-469e-b8f2-8d8b-3a0544d05f57@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
 <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com> <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
 <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com> <CAKuJGC_LWzJKGPecweK93nXRm1=j22HkqZdUHrragwab6zAUDw@mail.gmail.com>
 <f0ed81f8-a312-72b0-5da1-56cfbc1fa81e@cn.fujitsu.com> <CAKuJGC9YY-1i-Hxq7=8E_pd19xOA7Tt0ckYEpwJhrgtSbardOA@mail.gmail.com>
 <CAKuJGC9UZ8cb8W_XcqVEPsv7UAi7P=UjY6Gb4Uo6A5GMMj5qmw@mail.gmail.com>
 <b57b3e03-fc72-762f-1392-9a4ccafd0fcb@cn.fujitsu.com> <CAKuJGC8-VEm-3afkVmWzk+kVdxHZECp1soyksN4fvEJkJkB2GA@mail.gmail.com>
 <CAKuJGC8zCNwY__wbv0H24COrqu9Nxj9K3iLPcjTdxViEJNpEEQ@mail.gmail.com> <cfdab92f-469e-b8f2-8d8b-3a0544d05f57@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Wed, 24 May 2017 09:28:58 +0530
Message-ID: <CAKuJGC9o46w2w6qNyzNNMuMR9OfK7fY-NNuUPA5_hc5yJYE6BA@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Only recovery needs to be implemented now.
>
> Thanks,
> Qu
>
Once recovery is implemented, I'll try again.

Just one suggestion: Optionally, It is possible to print filename for
these detected blocks. For ex, if corruption happened on a
old/unwanted archived log file  (/var/log/nginx_access_20160101.log)
I don't need to panic, as I can live without that file. Or possibly
delete that file, so that scrub doesn't report errors.


-- 
----
Cheers,
Lakshmipathi.G
