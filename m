Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:32878 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbcCULUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 07:20:39 -0400
Received: by mail-qg0-f44.google.com with SMTP id a36so117472381qge.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 04:20:38 -0700 (PDT)
Subject: Re: btrfs fi du ERROR
To: Martin Volf <martin.volf.42@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAM1AHpQgH=Zn_k_pHMTpYfdY_xdrOZxo=x8R=Wd7nZ3gcsVX3w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EFD8B1.6050002@gmail.com>
Date: Mon, 21 Mar 2016 07:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAM1AHpQgH=Zn_k_pHMTpYfdY_xdrOZxo=x8R=Wd7nZ3gcsVX3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-21 02:37, Martin Volf wrote:
> Hello,
>
> I have just tried the new "btrfs fi du" command from btrfs-progs 4.5
> on 4.4.6 linux kernel, and it gave me:
>
> # btrfs fi du /bin
>       Total   Exclusive  Set shared  Filename
> (many lines of output for individual files, probably OK)
> ...
> ERROR: cannot check space of '/bin': Unknown error -1
>
> The -1 is ETXTBSY in this case:
>
> # strace -o log btrfs fi du /bin &>/dev/null; tail log
>
> newfstatat(3, "login", {st_mode=S_IFREG|0755, st_size=44784, ...}, 0) = 0
> stat("/bin/login", {st_mode=S_IFREG|0755, st_size=44784, ...}) = 0
> open("/bin/login", O_RDWR)              = -1 ETXTBSY (Text file busy)
> close(3)                                = 0
> write(2, "ERROR: ", 7)                  = 7
> write(2, "cannot check space of '/bin': Un"..., 46) = 46
> write(2, "\n", 1)                       = 1
> write(1, "     Total   Exclusive  Set shar"..., 3161) = 3161
> exit_group(1)                           = ?
> +++ exited with 1 +++
>
> Read-only snapshots give Unknown error -1 too, this time EROFS.
>
> Is it expected?
>
Given that we're apparently trying to open the file with O_RDWR, yes 
that is expected.  What's not expected is that we're opening the file 
writable...

I'll see if I can get a patch put together some time today to fix that.
