Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:57357 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753058AbeF1Rh7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 13:37:59 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>, Remi Gauvin <remi@georgianit.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
 <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it>
Date: Thu, 28 Jun 2018 19:37:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/28/2018 04:17 PM, Chris Murphy wrote:
> Btrfs does two, maybe three, bad things:
> 1. No automatic resync. This is a net worse behavior than mdadm and
> lvm, putting data at risk.
> 2. The new data goes in a single chunk; even if the user does a manual
> balance (resync) their data isn't replicated. They must know to do a
> -dconvert balance to replicate the new data. Again this is a net worse
> behavior than mdadm out of the box, putting user data at risk.
> 3. Apparently if nodatacow, given a file with two copies of different
> transid, Btrfs won't always pick the higher transid copy? If true
> that's terrible, and again not at all what mdadm/lvm are doing.

All these could be avoided simply not allowing a multidevice filesystem to mount without ensuring that all the devices have the same generation.

In the past I proposed a mount.btrfs helper; I am still thinking that it would be the right place to
a) put all the check before mounting the filesystem
b) print the correct information in order to help the user on what he has to do to solve the issues

Regarding your point 3), it must be point out that in case of NOCOW files, even having the same transid it is not enough. It still be possible that a copy is update before a power failure preventing the super-block update.
I think that the only way to prevent it to happens is:
  1) using a data journal (which means that each data is copied two times)
OR
  2) using a cow filesystem (with cow enabled of course !)

I think that this is a good example of why a HW Raid controller battery backed could be better than a SW raid. Of course the likelihood of a lot of problems could be reduced using a power supply.


BR
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
