Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34081 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758551AbcH3VqF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 17:46:05 -0400
Received: by mail-oi0-f54.google.com with SMTP id l203so45361133oib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 14:45:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO8kTBoPHx3jkeN+zdygEMZz9ejTeWGwQireRtDGDNrncQ@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
 <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
 <CA+WRLO8XVaK5FK9VUt=pOgoyqYm30_yxTnCd+5zdYx5Xx6jAcw@mail.gmail.com>
 <CA+WRLO-cvepjj53xCoq=RiEmTV-6cqL+G6nQe+WnTPyWNDOUZA@mail.gmail.com>
 <CA+WRLO-1oJLZ56EivVTg=bycNhfpOt8ovLrLbgnNeCVKgvbxhQ@mail.gmail.com>
 <CAJCQCtQddXz26cjp=tGcO5d5E9N=Zmjdd=qwonjGdh+NJ7aLQQ@mail.gmail.com>
 <CAJCQCtRGpAgGq9dpv432ES9OUHG4fDkt+DviapaCyg0Jtc2gVA@mail.gmail.com> <CA+WRLO8kTBoPHx3jkeN+zdygEMZz9ejTeWGwQireRtDGDNrncQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 30 Aug 2016 15:45:58 -0600
Message-ID: <CAJCQCtRUhjSCKRm5cYEqQy6WstthnrwzjKYo6Ck0xzG2LhmPxw@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 3:23 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> On Wed, Aug 31, 2016 at 4:28 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> But I'd try a newer kernel before you
>> give up on it.
>
>
> Any recommendations on liveCDs that have recent kernels & btrfs tools?
> For no apparent reason system isn't booting normally either, and I'm
> reluctant to fix that before at least confirming the things I at least
> partially care about have a recent backup.

Fedora 25 Alpha released today with kernel 4.8rc2 and btrfs-progs 4.6.1.
https://getfedora.org/en/workstation/prerelease/

The top green "Download" button offers GNOME. If you want something
smaller, on the right hand side are netinstall images with the same
kernel and progs, but no GUI. You can choose the Troubleshooting menu,
and then the Rescue a Fedora System option. It boots, and then you're
at a text UI where you can just get to a shell, option 3.

The easiest way to create a USB stick is with dd and it'll boot
practically anything, BIOS, UEFI, even Macs. Not all wireless firmware
is included in these media, if you have a wired connection it'll be
easier to get dmesg and and contents of btrfs check off. If you opt
for the larger image (GNOME), it's a bit easier to get the terminal
output into a file and either scp it to another computer or you can
also use fpaste <filename> and it'll spit back a URL where it uploaded
the text.




-- 
Chris Murphy
