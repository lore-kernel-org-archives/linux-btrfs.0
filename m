Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:47006 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdKOSQ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 13:16:57 -0500
Received: by mail-lf0-f45.google.com with SMTP id k66so15231804lfg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 10:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1948454.KW55iiPqHI@merkaba>
References: <20171113225046.GD28899@suse.cz> <20171114185331.GJ28899@twin.jikos.cz>
 <20171115143906.GM28899@twin.jikos.cz> <1948454.KW55iiPqHI@merkaba>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Wed, 15 Nov 2017 20:16:56 +0200
Message-ID: <CAK5rZE6gC-7pmAJSrrHEfEXVFdZ51MOwAKugHpmihrm6LwEnFQ@mail.gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, terrelln@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/17, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Somehow I am happy that I still have a plain Ext4 for /boot. :)

You may use uncompressed btrfs for /boot.
Both Syslinux (my choice) and Grub supports it.
