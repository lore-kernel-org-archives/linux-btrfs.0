Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:41894 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeEBTZx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 15:25:53 -0400
Received: by mail-io0-f176.google.com with SMTP id e12-v6so18841448iob.8
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 12:25:52 -0700 (PDT)
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Wed, 02 May 2018 19:25:41 +0000
Message-ID: <CAJH6TXhuyR0Kn9Uq2xZ6qvJhAmeeUOF7uvyyYT9ns10uuM_5eg@mail.gmail.com>
Subject: Re: RAID56 - 6 parity raid
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/2018 03:47 AM, Duncan wrote:
> Meanwhile, have you looked at zfs? Perhaps they have something like that?

Yes, i've looked at ZFS and I'm using it on some servers but I don't like
it too much for multiple reasons, in example:

1) is not officially in kernel, we have to build a module every time with
DKMS
2) it does not forgive, if you add the wrong device to a pool, you are
gone, you can't remove it without migrating all data and creating the new
pool from scratch. If, for mistake, you add a single device to a RAID-Z3,
you totally loose the whole redundancy and so on.
3) doesn't support expansion of RAID-Z one disk per time. if you want to
expand a RAIDZ, you have to create another pool and then stripe over it.

I'm new to BTRFS (if fact, i'm not using it) and I've seen in the status
page that "it's almost ready".
The only real missing part is a stable, secure and properly working RAID56,
so i'm thinking why most effort aren't directed to fix RAID56 ?

There are some environments where a RAID1/10 is too expensive and a RAID6
is mandatory,
but with the current state of RAID56, BTRFS can't be used for valuable data

Also, i've seen that to fix write hole, a dedicated disk is needed ? Is
this true ?
I cant' create a 6 disks RAID6 with only 6 disks and no write-hole like
with ZFS ?
