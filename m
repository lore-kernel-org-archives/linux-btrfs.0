Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:52913 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751238AbeBRJe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Feb 2018 04:34:56 -0500
Date: Sun, 18 Feb 2018 10:34:55 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczko.tomasz@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: your mail
Message-ID: <20180218093454.GA13420@polanet.pl>
References: <CABB28Cw2+jYynXk1e+Lbx+4otsj5BLXucVV6W3+kvm3RDbH_AQ@mail.gmail.com>
 <20180218092802.GA25085@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20180218092802.GA25085@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 18, 2018 at 10:28:02 +0100, Tomasz Pala wrote:

> I've already noticed this problem on February 10th:
> [btrfs-progs] coreutils-like -i parameter, splitting permissions for various tasks
> 
> In short: not possible. Regular user can only create subvolumes.

Not possible "oficially". Axel Burri has replied with more helpful approach:
https://github.com/digint/btrfs-progs-btrbk

Unfortunately this issue was not picked up by any developer, so for now
we can only wait for splitting libbtrfsutil so this task could be easier.

-- 
Tomasz Pala <gotar@pld-linux.org>
