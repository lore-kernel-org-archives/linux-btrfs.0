Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:42814 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750794AbdKCF6X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Nov 2017 01:58:23 -0400
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk>
 <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com>
 <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <06352a91-4076-8c2a-3079-890e68abcdf5@rqc.ru>
Date: Fri, 3 Nov 2017 08:58:22 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/17 04:39, Dave wrote:
> I'm going to make this change now. What would be a good way to
> implement this so that the change applies to the $HOME/.cache of each
> user?
I'd make each user's .cache a symlink (should work but if it won't then 
bind mount) to a per-user directory in some separately mounted volume 
with necessary options.

--

With Best Regards,
Marat Khalili
