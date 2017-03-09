Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56393 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752887AbdCIJtm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 04:49:42 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:59824)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cluhU-000Lqr-0e
        for linux-btrfs@vger.kernel.org; Thu, 09 Mar 2017 09:49:36 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cluhP-0005Cm-UE
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Mar 2017 09:49:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22721.9515.564892.221096@tree.ty.sabi.co.uk>
Date: Thu, 9 Mar 2017 09:49:31 +0000
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
In-Reply-To: <0d731a6d-4677-1d58-9f79-a8d7d2bcac37@gmail.com>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
        <22712.48434.400550.346157@tree.ty.sabi.co.uk>
        <284e9d01-3e69-705e-dd88-ebe047e2e4b8@gmail.com>
        <22716.25419.146443.191478@tree.ty.sabi.co.uk>
        <0d731a6d-4677-1d58-9f79-a8d7d2bcac37@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Consider the common case of a 3-member volume with a 'raid1'
>> target profile: if the sysadm thinks that a drive should be
>> replaced, the goal is to take it out *without* converting every
>> chunk to 'single', because with 2-out-of-3 devices half of the
>> chunks will still be fully mirrored.

>> Also, removing the device to be replaced should really not be
>> the same thing as balancing the chunks, if there is space, to be
>> 'raid1' across remaining drives, because that's a completely
>> different operation.

> There is a command specifically for replacing devices.  It
> operates very differently from the add+delete or delete+add
> sequences. [ ... ]

Perhaps it was not clear that I was talking about removing a
device, as distinct from replacing it, and that I used "removed"
instead of "deleted" deliberately, to avoid the confusion with
the 'delete' command.

In the everyday practice of system administration it often
happens that a device should be removed first, and replaced
later, for example when it is suspected to be faulty, or is
intermittently faulty. The replacement can be done with
'replace' or 'add+delete' or 'delete+add', but that's a
different matter.

Perhaps I should have not have used the generic verb "remove",
but written "make unavailable".

This brings about again the topic of some "confusion" in the
design of the Btrfs multidevice handling logic, where at least
initially one could only expand the storage space of a
multidevice by 'add' of a new device or shrink the storage space
by 'delete' of an existing one, but I think it was not conceived
at Btrfs design time of storage space being nominally constant
but for a device (and the chunks on it) having a state of
"available" ("present", "online", "enabled") or "unavailable"
("absent", "offline", "disabled"), either because of events or
because of system administrator action.

The 'missing' pseudo-device designator was added later, and
'replace' also later to avoid having to first expand then shrink
(or viceversa) the storage space and the related copying.

My impression is that it would be less "confused" if the Btrfs
device handling logic were changed to allow for the the state of
"member of the multidevice set but not actually available" and
the related consequent state for chunks that ought to be on it;
that probably would be essential to fixing the confusing current
aspects of recovery in a multidevice set. That would be very
useful even if it may require a change in the on-disk format to
distinguish the distinct states of membership and availability
for devices and mark chunks as available or not (chunks of course
being only possible on member devices).

That is, it would also be nice to have the opposite state of "not
member of the multidevice set but actually available to it", that
is a spare device, and related logic.

Note: simply setting '/sys/block/$DEV/device/delete' is not a
good option, because that makes the device unavailable not just
to Btrfs, but also to the whole systems. In the ordinary practice
of system administration it may well be useful to make a device
unavailable to Btrfs but still available to the system, for
example for testing, and anyhow they are logically distinct
states. That also means a member device might well be available
to the system, but marked as "not available" to Btrfs.
