Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:34439 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933600AbcI0DKq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 23:10:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 27 Sep 2016 12:10:37 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
In-Reply-To: <CAJCQCtQ+uaMCCW81+ePF6scGsTu+MEu1arCQ0wTJhwS8EN8S=A@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <CAJCQCtQ+uaMCCW81+ePF6scGsTu+MEu1arCQ0wTJhwS8EN8S=A@mail.gmail.com>
Message-ID: <8f88272e6c5e69563d6734f411c680ae@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-21 11:51, Chris Murphy wrote:


> So if it happens again, first capture the above two bits of
> information, and then if  you feel like testing kernel 4.8rc7 do that.
> It has a massive pile of enoscp related rework and I bet Josef would
> like to know if the problem reproduces with that kernel. As in, just
> change kernels, don't try to fix it with balance first.

Looks like 4.8 helped (running 4.8rc8 now).

With 4.7, after balance, the "used" value continued to grow, to around 
300 GB, although used space shown by "df" was more or less constant at 
130-140 GB:

# btrfs fi show /var/lib/lxd
Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
         Total devices 2 FS bytes used 135.40GiB <--------- was growing
         devid    1 size 423.13GiB used 277.03GiB path /dev/sda3
         devid    2 size 423.13GiB used 277.03GiB path /dev/sdb3


After upgrading to 4.8rc8, "used" value dropped, so hopefully it's fixed 
now.


Tomasz Chmielewski
https://lxadm.com
