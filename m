Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:56994 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934725AbdKCC76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 22:59:58 -0400
Received: by mail-wm0-f51.google.com with SMTP id z3so2410645wme.5
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 19:59:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f621ce21-5984-2d68-4fb5-8f45e13cb760@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net> <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk> <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com> <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
 <f621ce21-5984-2d68-4fb5-8f45e13cb760@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Thu, 2 Nov 2017 22:59:36 -0400
Message-ID: <CAH=dxU5_CA3ZqKdTQ5SCDEWwcktOLpjWv20Q5CxhPz3DTZCjig@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 2, 2017 at 7:07 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-11-01 21:39, Dave wrote:
>> I'm going to make this change now. What would be a good way to
>> implement this so that the change applies to the $HOME/.cache of each
>> user?
>>
>> The simple way would be to create a new subvolume for each existing
>> user and mount it at $HOME/.cache in /etc/fstab, hard coding that
>> mount location for each user. I don't mind doing that as there are
>> only 4 users to consider. One minor concern is that it adds an
>> unexpected step to the process of creating a new user. Is there a
>> better way?
>>
> The easiest option is to just make sure nobody is logged in and run the
> following shell script fragment:
>
>     for dir in /home/* ; do
>         rm -rf $dir/.cache
>         btrfs subvolume create $dir/.cache
>     done
>
> And then add something to the user creation scripts to create that
> subvolume.  This approach won't pollute /etc/fstab, will still exclude the
> directory from snapshots, and doesn't require any hugely creative work to
> integrate with user creation and deletion.
>
> In general, the contents of the .cache directory are just that, cached data.
> Provided nobody is actively accessing it, it's perfectly safe to just nuke
> the entire directory...

I like this suggestion. Thank you. I had intended to mount the .cache
subvolumes with the NODATACOW option. However, with this approach, I
won't be explicitly mounting the .cache subvolumes. Is it possible to
use "chattr +C $dir/.cache" in that loop even though it is a
subvolume? And, is setting the .cache directory to NODATACOW the right
choice given this scenario? From earlier comments, I believe it is,
but I want to be sure I understood correctly.
