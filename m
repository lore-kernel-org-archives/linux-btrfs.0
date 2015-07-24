Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:35870 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbbGXTtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 15:49:05 -0400
Received: by vnk197 with SMTP id 197so12688601vnk.3
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 12:49:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437766634.808316031@apps.rackspace.com>
References: <1437763277.673610371@apps.rackspace.com>
	<CAJCQCtRBsKM9=yJ+Qj=aikW86+hqDkAZ08nRyjVLjmKRXW7HSA@mail.gmail.com>
	<1437766634.808316031@apps.rackspace.com>
Date: Fri, 24 Jul 2015 13:49:03 -0600
Message-ID: <CAJCQCtR3nJidtsTzWsi-9fspUCzoH8qcQGHMZXXo5xGqJG2w5g@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_systemd_=3A_Timed_out_waiting_for_defice_dev=2Ddisk=2D?=
	=?UTF-8?Q?by=E2=80=A6?=
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 1:37 PM, Vincent Olivier <vincent@up4.com> wrote:
> On Jul 24, 2015, at 3:27 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I'm not sure if its a systemd bug, a udev bug, or a btrfs device scan
> bug, or a fast boot with slow spin up of the drives in the Btrfs.
>
> This system doesn't boot from this 12 disk Btrfs, correct?
>
> Most exact, yes.
>
>
>
>
> You could try changing fstab mount options to include:
> noauto,x-systemd.automount
>
> I did and it worked. Isn’t it a tad ugly though ?

No. The noauto is appropriate because you don't want this volume to
cause basic.target to fail. By using noauto, the volume isn't added to
local-fs.target.

You could experiment with x-systemd.device-timeout= but that's just
going to cause your boot to delay waiting for it; and I'm not sure
it'll actually work. You may have to iterate.

> Mount time is very close to 10 seconds which is quite high I think, no ?

Well that's a Btrfs thing, and it sounds like right now that's normal
for a volume of this size. Since it has to find all the devices, read
their superblocks, make sure the fs is minimally consistent, it
doesn't sound too bad.



-- 
Chris Murphy
