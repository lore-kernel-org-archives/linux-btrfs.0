Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:44378 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbdKXHsB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 02:48:01 -0500
Received: by mail-ua0-f172.google.com with SMTP id j14so14152909uag.11
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 23:48:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com> <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 24 Nov 2017 13:17:20 +0530
Message-ID: <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
Subject: Re: misc/021-image-multi-devices fails on latest btrfs-devel/misc-next
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I'm using btrfs-progs devel branch. mount command is failing with misc/021.
When I tried to manually mount it. dmesg shows  "unrecognized super
flag: 17179869184"
and interestingly "df -h" shows 16E as available!

https://asciinema.org/a/4JGYg7YGQz1PHtdBRJ6AVw0fh

Let me check further.
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Fri, Nov 24, 2017 at 9:55 AM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
> Hi Qu,
>
> I'm using the same instance. Let me check again with and without the
> commits list on Nov-23
> (https://github.com/kdave/btrfs-devel/commits/misc-next) and get back
> with results.
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
