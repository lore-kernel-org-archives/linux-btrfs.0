Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33064 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbcF0Rqv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 13:46:51 -0400
Received: by mail-oi0-f45.google.com with SMTP id u201so210499351oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 10:46:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
 <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com> <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 11:46:50 -0600
Message-ID: <CAJCQCtTcDc2H3KYHe1oqT9QnZq2pt8Mn=SX6ZpMHT8bTPdE8_w@mail.gmail.com>
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
To: Chris Murphy <lists@colorremedies.com>
Cc: Nick Austin <nick@smartaustin.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 11:29 AM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Next is to decide to what degree you want to salvage this volume and
> keep using Btrfs raid56 despite the risks

Forgot to complete this thought. So if you get a backup, and decide
you want to fix it, I would see if you can cancel the replace using
"btrfs replace cancel <mp>" and confirm that it stops. And now is the
risky part, which is whether to try "btrfs add" and then "btrfs
remove" or remove the bad drive, reboot, and see if it'll mount with
-o degraded, and then use add and remove (in which case you'll use
'remove missing').

The first you risk Btrfs still using the flaky bad drive.

The second you risk whether a degraded mount will work, and whether
any other drive in the array has a problem while degraded (like an
unrecovery read error from a single sector).


-- 
Chris Murphy
