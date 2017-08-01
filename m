Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37864 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdHAPSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 11:18:32 -0400
Received: by mail-lf0-f68.google.com with SMTP id x16so1757047lfb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 08:18:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3cfa0$3afe82cb$bc3321e6$72d33baa@cox.net>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net> <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
 <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net> <CAK5rZE6vMujb5KEqwUZD2-ZmZ4vi2T4+J2BzTLi9qqx8GeFKgg@mail.gmail.com>
 <pan$3b64a$a9b921fc$3e4651f5$627d0636@cox.net> <CAK5rZE6urkaR7B8MxA_MB_e9PfNwDHuu_APnKCBZ+EVJrDo7bw@mail.gmail.com>
 <pan$3cfa0$3afe82cb$bc3321e6$72d33baa@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Tue, 1 Aug 2017 17:18:30 +0200
Message-ID: <CAK5rZE7=1B51=Ue_CjhjN_z6BoQ=4P-4=icxwmgkOKHF_jyVxw@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/1/17, Duncan <1i5t5.duncan@cox.net> wrote:
> Imran Geriskovan posted on Mon, 31 Jul 2017 22:32:39 +0200 as excerpted:
>>>> Now the init on /boot is a "19 lines" shell script, including lines
>>>> for keymap, hdparm, crytpsetup. And let's not forget this is possible
>>>> by a custom kernel and its reliable buddy syslinux.

>>> And I'm using dracut for that, tho quite cut down from its default,
>>> with a monolithic kernel and only installing necessary dracut modules.

>> Just create minimal bootable /boot for running below init.
>> (Your initramfs/rd is a bloated and packaged version of this anyway.)
>> Kick the rest. Since you a have your own kernel you are not far away
>> from it.

> Thanks.  You just solved my primary problem of needing to take the time
> to actually research all the steps and in what order I needed to do them,
> for a hand-rolled script. =:^)

It's just a minimal one. But it is a good start. For possible extensions
extract your initramfs and explore it. Dracut is bloated. Try mkinitcpio.

Once your have your self hosting bootmng, kernel, modules, /boot, init, etc
chain, you'll be shocked to realize you have been spending so much time for
that bullshit while trying to keep them up..

Get to this point in the shortest possible time. Save your precious
time. And reclaim your systems reliability.

For X, you'll still need udev or eudev.
