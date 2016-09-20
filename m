Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:53317 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbcITH4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 03:56:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 20 Sep 2016 16:56:50 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Peter Becker <floyd.net@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
In-Reply-To: <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk>
 <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
Message-ID: <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-20 16:27, Peter Becker wrote:

> You have 417(total)-131(used) blocks wo are only partial filled.
> You should balance your file-system.

(...)

> #or a full balance
> btrfs balance start /mnt

OK, does it mean that btrfs needs some userspace daemon which does the 
following from time to time (how often?):

1) btrfs fi show /mountpoint(s)

2) if "used" is more than 90% (or 80%? or 70%?) of "size" - run a full 
balance

3) ...unless "btrfs fi df" shows that "used" is 95% (?) or more of 
"total", then don't bother, as we're "really" full

?


Tomasz Chmielewski
https://lxadm.com

