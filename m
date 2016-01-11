Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33413 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759347AbcAKW6C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 17:58:02 -0500
Received: by mail-wm0-f52.google.com with SMTP id f206so232132201wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 14:58:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
References: <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk> <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 23:57:40 +0100
Message-ID: <CA+9GZUjrdmwYREWdzYy_DYiUs7+tcvuGbghSYyzoB4DhBGLowg@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 10:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
>>> Interesting. I did not know of this bug. It's pretty rare.
>> Not really. It shows up maybe on average once a week on IRC. It
>> gets reported much less on the mailing list.
>
> Is there a pattern? Does it only happen at a 2TiB threshold?

In my case, it seems to me that there's two bugs that I encountered:

1. the free space cache being invalid blocked any and all resizes.
This was fixed with fsck (maybe resizing the fs to smaller and then to
max size contributed to the fix as well)

2. when i copy files onto the fs, most of the time the resizes work
correctly, but every now and then they won't, and it seems to me like
this only happens when there's a lot of data being copied, the cpu is
hot, likely the usb controller is hot, etc. It seems to me like at
that point the hardware just becomes less robust (without exactly
becoming buggy).
