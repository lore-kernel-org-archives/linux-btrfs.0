Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:35693 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbGXT1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 15:27:03 -0400
Received: by vnaa140 with SMTP id a140so12537651vna.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 12:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437763277.673610371@apps.rackspace.com>
References: <1437763277.673610371@apps.rackspace.com>
Date: Fri, 24 Jul 2015 13:27:02 -0600
Message-ID: <CAJCQCtRBsKM9=yJ+Qj=aikW86+hqDkAZ08nRyjVLjmKRXW7HSA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_systemd_=3A_Timed_out_waiting_for_defice_dev=2Ddisk=2D?=
	=?UTF-8?Q?by=E2=80=A6?=
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure if its a systemd bug, a udev bug, or a btrfs device scan
bug, or a fast boot with slow spin up of the drives in the Btrfs.

This system doesn't boot from this 12 disk Btrfs, correct?

You could try changing fstab mount options to include:
noauto,x-systemd.automount


I do this for the EFI System partition at /boot/efi because I don't
want it mounted unless something accesses that path - so at that time
only does it get mounted. In your case it sounds similar, just don't
mount until accessed, which wouldn't happen until basic.target is
finished anyway (?) if it's not a boot drive.


http://www.freedesktop.org/software/systemd/man/systemd.mount.html


Chris Murphy
