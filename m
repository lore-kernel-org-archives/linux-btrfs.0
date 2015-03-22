Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33126 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbCVRbA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 13:31:00 -0400
Received: by wgbcc7 with SMTP id cc7so128624126wgb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2015 10:30:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 22 Mar 2015 17:30:59 +0000
Message-ID: <CAAkAgPhF5GF5tq0Pck-dju-m7qf62LV8FobUHS2z6ibMwwUn2g@mail.gmail.com>
Subject: btrfs fstrim status (RAID5)
From: scruffters <scruffters@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I wondered if anybody could advise on the status of using fstrim with
BTRFS. The motivation for me is to finally try using SSD's in a R5
style configuration with some way of running maintenance overnight to
maintain performance...

There are various mentions of this online:
https://btrfs.wiki.kernel.org/index.php/RAID56

>"No support for discard? (possibly -- needs confirmation with cmason)"

Obviously fstrim is slightly different to discard, but the docs are
kinda patchy.

Can anybody advise or point me to more info?

Thanks :-)

PS.

My kernel is 3.2.0-4 (Debian Wheezy).
