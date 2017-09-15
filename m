Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:50156 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdIOTKX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 15:10:23 -0400
Received: by mail-wm0-f47.google.com with SMTP id e71so10635482wmg.4
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 12:10:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 15 Sep 2017 20:10:21 +0100
Message-ID: <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 September 2017 at 18:08, Kai Krakow <hurikhan77@gmail.com> wrote:
[..]
> According to Tomasz, your tests should not run at vastly different
> speeds because fragmentation has no impact on performance, quod est
> demonstrandum... I think we will not get to the "erat" part.

No. This is not precisely what I'm trying to tell.
Now however seeing that there is no precise/fully repeatable
methodology of performing proposed test I have huge doubts about what
is reported has effect has anything to do do with fragmentation or it
is side effect of using COW (which allow glue some number random
updates into larger sequential write IOs).

kloczek
-- 
Tomasz Kłoczko  LinkedIn: http://lnkd.in/FXPWxH
