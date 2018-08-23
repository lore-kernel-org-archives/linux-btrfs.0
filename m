Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:36728 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeHXDFv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 23:05:51 -0400
Received: by mail-wr1-f47.google.com with SMTP id m27-v6so5964265wrf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 16:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <ompef3$sim$1@blaine.gmane.org> <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com> <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com> <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
 <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
In-Reply-To: <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Fri, 24 Aug 2018 01:33:37 +0200
Message-ID: <CANznX5GBO2SQSr=vithFb7kErjo89_B7PALwo1TsAygrMFkSTg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_lazytime_mount_option=E2=80=94no_support_in_Btrfs?=
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 4:10 PM Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Also, once you've got the space cache set up by mounting once writable
> with the appropriate flag and then waiting for it to initialize, you
> should not ever need to specify the `space_cache` option again.

True.
I am not sure why I thought I have to keep cache-v2 in the rootflag
list. I guess I forgot it was meant to be removed after a reboot. Or
may be some old kernels misbehaved (always cleared the space-tree for
some reason and re-initialized a space-cache instead unless the flag
was there). But I removed it now and everything works as intended.
Thanks.
