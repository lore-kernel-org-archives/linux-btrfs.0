Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59122 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaGJPZ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 11:25:29 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so6131599lbi.25
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 08:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53BEA8BC.2000309@martos.bme.hu>
References: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>
 <53BEA8BC.2000309@martos.bme.hu>
From: Andrew Flerchinger <lorax3@gmail.com>
Date: Thu, 10 Jul 2014 11:25:07 -0400
Message-ID: <CAGTBuzR72Jmg46aZENbyjtcX1wQkqczPJ8yiutquj4+p_Bs6-w@mail.gmail.com>
Subject: Re: File server structure suggestion
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to increase the size of the vdev, not just the zpool. I want to
make a 3-drive array into a 4-drive array by adding a single drive
while still having one parity stripe across all data. Adding more
vdevs to a zpool isn't quite the same thing as online capacity
expansion. It's not something most businesses would do, which is why
the feature never made it into ZFS, but consumers are cheap and mdadm
supported it. From what I've read, btrfs supports it, too.

On Thu, Jul 10, 2014 at 10:52 AM, Tamas Papp <tompos@martos.bme.hu> wrote:
>
> On 07/10/2014 04:41 PM, Andrew Flerchinger wrote:
>>
>> what was going on. That sold me on the idea of data checksums, but I'd
>> rather stay in linux than BSD, and I previously made use of online
>> capacity expansion as needed, which ZFS doesn't support.
>
>
> What do you mean by that?
> What zfs doesn't support is reducing a pool.
>
>
> tamas
