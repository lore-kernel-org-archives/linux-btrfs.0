Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33376 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966864AbdEWOlD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 10:41:03 -0400
Received: by mail-ua0-f177.google.com with SMTP id e28so79330843uah.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 07:41:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC8-VEm-3afkVmWzk+kVdxHZECp1soyksN4fvEJkJkB2GA@mail.gmail.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
 <fdd3a98e-1c7c-2339-ece1-ea71977594d9@cn.fujitsu.com> <CAKuJGC-R=5j=rzMJioBtftq1305wpT1tcy+WuRzTv9+Q065qvQ@mail.gmail.com>
 <46db6693-3508-6845-e80f-0db1192d7bd2@cn.fujitsu.com> <CAKuJGC_LWzJKGPecweK93nXRm1=j22HkqZdUHrragwab6zAUDw@mail.gmail.com>
 <f0ed81f8-a312-72b0-5da1-56cfbc1fa81e@cn.fujitsu.com> <CAKuJGC9YY-1i-Hxq7=8E_pd19xOA7Tt0ckYEpwJhrgtSbardOA@mail.gmail.com>
 <CAKuJGC9UZ8cb8W_XcqVEPsv7UAi7P=UjY6Gb4Uo6A5GMMj5qmw@mail.gmail.com>
 <b57b3e03-fc72-762f-1392-9a4ccafd0fcb@cn.fujitsu.com> <CAKuJGC8-VEm-3afkVmWzk+kVdxHZECp1soyksN4fvEJkJkB2GA@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 23 May 2017 20:11:01 +0530
Message-ID: <CAKuJGC8zCNwY__wbv0H24COrqu9Nxj9K3iLPcjTdxViEJNpEEQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, "dsterba@suse.cz" <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I did multiple (upto 11) corruption on the same file. Seems like
it says 'CORRUPTED' when we corrupt two continuous data stripes and
reports 'RECOVERABLE' whenever possible.It looks fine.  You can find
the logs and test-scripts on below link. thanks.

https://github.com/Lakshmipathi/btrfs_offline_scrub

-- 
----
Cheers,
Lakshmipathi.G
