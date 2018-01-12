Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:32976 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754506AbeALU2W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 15:28:22 -0500
Received: by mail-it0-f54.google.com with SMTP id c102so2770903itd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 12:28:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20055256.49.1515779377187.JavaMail.gkos@dynomob>
References: <20055256.49.1515779377187.JavaMail.gkos@dynomob>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 12 Jan 2018 23:27:41 +0300
Message-ID: <CAGqmi76BMB5tJ2prr-PBwA-rRixeQQU5aT9HpYwQLBp3wP3CyQ@mail.gmail.com>
Subject: Re: btrfs subvolume mount with different options
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-12 20:49 GMT+03:00 Konstantin V. Gavrilenko <k.gavrilenko@arhont.com>:
> Hi list,
>
> just wondering whether it is possible to mount two subvolumes with different mount options, i.e.
>
> |
> |- /a  defaults,compress-force=lza
> |
> |- /b  defaults,nodatacow
>
>
> since, when both subvolumes are mounted, and when I change the option for one it is changed for all of them.
>
>
> thanks in advance.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Not possible for now.

-- 
Have a nice day,
Timofey.
