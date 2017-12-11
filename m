Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38123 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdLKFTT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 00:19:19 -0500
Received: by mail-wm0-f54.google.com with SMTP id 64so11807759wme.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 21:19:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH=dxU47-52-asM5vJ_-qOpEpjZczHw7vQzgi1-TeKm58++zBQ@mail.gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net> <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk> <CAH=dxU47-52-asM5vJ_-qOpEpjZczHw7vQzgi1-TeKm58++zBQ@mail.gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Mon, 11 Dec 2017 00:18:57 -0500
Message-ID: <CAH=dxU6wbCOaAK5NRRe-yRX1F349pKg6xOsQOfFzc7kCoDTJNw@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 someone wrote:
>
>
> > 2. Put $HOME/.cache on a separate BTRFS subvolume that is mounted
> > nocow -- it will NOT be snapshotted

I did exactly this. It servers the purpose of avoiding snapshots.
However, today I saw the following at
https://wiki.archlinux.org/index.php/Btrfs

Note: From Btrfs Wiki Mount options: within a single file system, it
is not possible to mount some subvolumes with nodatacow and others
with datacow. The mount option of the first mounted subvolume applies
to any other subvolumes.

That makes me think my nodatacow mount option on $HOME/.cache is not
effective. True?

(My subjective performance results have not been as good as hoped for
with the tweaks I have tried so far.)
