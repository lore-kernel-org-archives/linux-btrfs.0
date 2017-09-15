Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:46641 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdIONHX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 09:07:23 -0400
Received: by mail-wm0-f51.google.com with SMTP id i189so8187127wmf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 06:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59BBB15E.8010002@sarach.com.pl>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 15 Sep 2017 14:07:21 +0100
Message-ID: <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: =?UTF-8?Q?Micha=C5=82_Soko=C5=82owski?= <michal@sarach.com.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 September 2017 at 11:54, Michał Sokołowski <michal@sarach.com.pl> wrote:
[..]
>> Just please some example which I can try to replay which ill be
>> showing that we have similar results.
>
> Case #1
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu cow2 storage
> -> guest BTRFS filesystem
> SQL table row insertions per second: 1-2
>
> Case #2
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu raw storage ->
> guest EXT4 filesystem
> SQL table row insertions per second: 10-15

Q -1) why you are comparing btrfs against ext4 on top of the btrfs
which is doing own COW operations on bottom of such sandwiches ..  if
we SUPPOSE to be talking about impact of the fragmentation on top of
btrfs?
Q 0) what do you think that you measure here?
Q 1) how did you produce those time measurements? time command?
looking on the watch?
Q 2) why there are ranges of timings? did you repeat some operations
few times (how many times and with or without dropping caches or doing
reboots?)
Q 3) What kind of SQL engine? with what kind of settings? with what
kind of tables? (indexes? foreign keys?) What kind of transactions
semantics?
Q 4) where is the example set of inserts which I can replay in my
setup? did you drop caches before batch of inserts? (do you know that
every insert generates as well some number of read IOs so information
is something is already cached before batch of inserts is *crucial*)
Did you restart SQL engine?
Q 5) are both test have been executed on the same box? if not which
one version of the kernel(s) have been used?
Q 6) ) effectively how many IOs have been done during those tests? how
did you measured those numbers (dtrace? perf? systemtap?)
Q7) why you are running your tests over qemu? Is it anything more
running on the host system during those tests?
.
.
.
I can probably make this list of questions 2 or 3 times longer.

koczek
--
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
