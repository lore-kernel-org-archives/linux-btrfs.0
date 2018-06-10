Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:40060 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753672AbeFJDxn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jun 2018 23:53:43 -0400
Received: by mail-ot0-f180.google.com with SMTP id w9-v6so14614236otj.7
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jun 2018 20:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 9 Jun 2018 21:53:41 -0600
Message-ID: <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Simon Kaiser <simon.kaiser@kit.edu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 9, 2018 at 7:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Indeed, the corrupted bytenr is 0x4bc98004.
> Looks pretty like a bit flip in the 3rd lowest bit.
>
> It can be fixed by manually patching the corrupted leaf to get rid of
> the bitflip.
> I could provide a special branch of btrfs-progs to fix it easily.
>
> But before that, it's better to do a scrub to see if there is other
> similar problems, so I could fix them all.
>

Do you think Simon should try -o ro and -o ro,norecovery and see if he
can update backups the easy way first? And then use the offline scrub
to check for additional problems?

Simon, the offline scrub is done unmounted with 'btrfs check
--check-data-csum <dev>' and it is a read-only check.


-- 
Chris Murphy
