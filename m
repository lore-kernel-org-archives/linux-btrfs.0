Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37185 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754379AbdKCHUO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 03:20:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAWGp-0001Hh-DO
        for linux-btrfs@vger.kernel.org; Fri, 03 Nov 2017 08:20:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Fri, 3 Nov 2017 08:19:59 +0100
Message-ID: <20171103081959.22fc5a24@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
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
        <06352a91-4076-8c2a-3079-890e68abcdf5@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 3 Nov 2017 08:58:22 +0300
schrieb Marat Khalili <mkh@rqc.ru>:

> On 02/11/17 04:39, Dave wrote:
> > I'm going to make this change now. What would be a good way to
> > implement this so that the change applies to the $HOME/.cache of
> > each user?  
> I'd make each user's .cache a symlink (should work but if it won't
> then bind mount) to a per-user directory in some separately mounted
> volume with necessary options.

On a systemd system, each user already has a private tmpfs location
at /run/user/$(id -u).

You could add to the central login script:

# CACHE_DIR="/run/user/$(id -u)/cache"
# mkdir -p $CACHE_DIR && ln -snf $CACHE_DIR $HOME/.cache

You should not run this as root (because of mkdir -p).

You could wrap it into an if statement:

# if [ "$(whoami)" -ne "root" ]; then
#   ...
# fi


-- 
Regards,
Kai

Replies to list-only preferred.

