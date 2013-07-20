Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:43566 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3GTPPv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 11:15:51 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so4138876vea.16
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 08:15:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Jul 2013 17:15:50 +0200
Message-ID: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
Subject: Lots of harddrive chatter on after booting with btrfs on root (slow boot)
From: Jason Russell <jasrusable@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been using btrfs for my root partition for about a month on
archlinux and recently Ive started using the i3 window manager and
starting X manually and I now boot to run level 3 (multi-user.target
for systemd) and Ive noticed that booting archlinux on a btrfs root,
there is a lot off hdd chatter after the login prompts are displayed,
which doesnt happen with ext4 on root, so I have done some testing and
comparisons.

I have stripped down two arch installs, one with btrfs root and one
with ext4, (same laptop, same hdd) I removed all packages except for
the base group. On the btrfs root, there is about +- 15 seconds of hdd
chatter and it takes a long time to log in from the prompts, with the
ext4 root, the computer is silent after the prompts pop up and login
is almost instant. The prompts of the two installs pop up at more or
less the same time (+- 3 seconds) but the login on the btrfs root
takes muuch longer than the ext4.

Ive also noted that this excessive hdd chatter does not occur
immediately after a fresh format with arch on btrfs root.

Ive made some deductions/assumptions:
This only seems to occur with btrfs roots.
This only happens after some number of reboots OR after the partition
fills up a little bit.
Im pretty sure of ruled out everything except for the filesystem.


I have just done two clean installs to more thoroughly compare ext4
and btrfs roots. So far no excessive hdd chatter from btrfs.

I have also seen what I have described on two other computers
(different hardware entirely) where there is lots of hdd chatter from
btrfs root, and nothing from ext4.

Here are two threads:
https://bbs.archlinux.org/viewtopic.php?pid=1117932
https://bbs.archlinux.org/viewtopic.php?pid=1301684

Any ideas?

Thanks,

--
Jason Russell
