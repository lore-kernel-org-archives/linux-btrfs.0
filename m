Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:44179 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbbHNCjZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 22:39:25 -0400
Received: from smtp30.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1DC7A380174
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 22:39:24 -0400 (EDT)
Received: from smtp30.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1A362380185
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 22:39:24 -0400 (EDT)
Received: from app57.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1195A380174
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 22:39:23 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app57.wa-webapps.iad3a (Postfix) with ESMTP id B94D7180064
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 22:39:23 -0400 (EDT)
Date: Thu, 13 Aug 2015 22:39:23 -0400 (EDT)
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <CAJCQCtQ2fK4S_RJRzg3EE+0qu4ipFtDVfshWuxjnF2nzpF8vLA@mail.gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
 <55BB0A39.1050208@cn.fujitsu.com>
 <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
 <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
 <55C017E7.40704@cn.fujitsu.com>
 <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
 <55C02AF9.3070600@cn.fujitsu.com>
 <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
 <55C0A1ED.6020407@gmail.com>
 <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com> <1439505513.484813682@apps.rackspace.com>
 <CAJCQCtQ2fK4S_RJRzg3EE+0qu4ipFtDVfshWuxjnF2nzpF8vLA@mail.gmail.com>
Message-ID: <1439519963.756418660@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have 2 snapshots a few days apart for incrementally backing up the volume but that's it.

I'll try without autodefrag tomorrow.

Vincent

-----Original Message-----
From: "Chris Murphy" <lists@colorremedies.com>
Sent: Thursday, August 13, 2015 19:19
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory

On Thu, Aug 13, 2015 at 4:38 PM, Vincent Olivier <vincent@up4.com> wrote:
> Hi,
>
> I think I might be having this problem too. 12 x 4TB RAID10 (original makefs, not converted from ext or whatnot). Says it has ~6TiB left. Centos 7. Dual Xeon CPU. 32GB RAM. ELRepo Kernel 4.1.5. Fstab options: noatime,autodefrag,compress=zlib,space_cache,nossd,noauto,x-systemd.automount

Well I think others have suggested 3000 snapshots and quite a few
things will get very slow. But then also you have autodefrag and I
forget the interaction of this with many snapshots since the snapshot
aware defrag code was removed.

I'd say file a bug with the full details of the hardware from the
ground up to the Btrfs file system. And include as an attachment,
dmesg with sysrq+t during this "hang". Usually I see t asked if
there's just slowness/delays, and w if there's already a kernel
message saying there's a blocked task for 120 seconds.


-- 
Chris Murphy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


