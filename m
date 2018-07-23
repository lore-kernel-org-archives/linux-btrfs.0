Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41458 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388097AbeGWQNX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 12:13:23 -0400
Subject: Re: Regression with crc32c selection? (solved - pilot error)
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
 <CAA7pwKMRuDLS64zqQuTHN4DbM2HE-wBkpPJw-7kmAy6NJxqg_g@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <3567df57-9390-6908-e17a-9d6f20126182@applied-asynchrony.com>
Date: Mon, 23 Jul 2018 17:11:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAA7pwKMRuDLS64zqQuTHN4DbM2HE-wBkpPJw-7kmAy6NJxqg_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/18 16:39, Patrik Lundquist wrote:
> $ uname -a
> Linux nas 4.17.0-1-amd64 #1 SMP Debian 4.17.8-1 (2018-07-20) x86_64 GNU/Linux
> 
> $ dmesg | grep Btrfs
> [    8.168408] Btrfs loaded, crc32c=crc32c-intel
> 
> $ lsmod | grep crc32
> crc32_pclmul           16384  0
> libcrc32c              16384  1 btrfs
> crc32c_generic         16384  0
> crc32c_intel           24576  2

Ooohh..thanks for that. I wouldn't be surprised it's because my libcrc
is built-in (probably because of built-in xfs) and at initialization time
doesn't see any modules, so it always selects the generic impl.
Since btrfs is only ever loaded last, the previous btrfs init code could
properly detect/load/use the crc32c-intel module.

I switched the crc32c impls to built-in and what do you know:

Jul 23 17:04:26 ragnarok kernel: Btrfs loaded, crc32c=crc32c-intel

\o/

Thanks Patrick!

Holger
