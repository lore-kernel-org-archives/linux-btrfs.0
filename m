Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:37892 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753633AbdG2Na5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 09:30:57 -0400
Received: by mail-qk0-f194.google.com with SMTP id v76so11680126qka.5
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 06:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201707291904.xAwWtZat%fengguang.wu@intel.com>
References: <20170726124958.18837-4-nefelim4ag@gmail.com> <201707291904.xAwWtZat%fengguang.wu@intel.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 29 Jul 2017 16:30:16 +0300
Message-ID: <CAGqmi77SH98ep4_YcUjYpPCDSAr8COUMmKBrHrgxFG+GWjW+qA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] Btrfs: heuristic add byte core set calculation
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-07-29 14:43 GMT+03:00 kbuild test robot <lkp@intel.com>:
> Hi Timofey,
>
> [auto build test ERROR on next-20170724]
> [cannot apply to btrfs/next v4.13-rc2 v4.13-rc1 v4.12 v4.13-rc2]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Timofey-Titovets/Btrfs-populate-heuristic-with-detection-logic/20170729-061208
> config: arm-arm5 (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "__aeabi_uldivmod" [fs/btrfs/btrfs.ko] undefined!
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

I will fix 64bit division and resend patch set

Thanks.

-- 
Have a nice day,
Timofey.
