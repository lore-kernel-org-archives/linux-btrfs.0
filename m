Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:47125 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbbHRRg2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 13:36:28 -0400
Date: Tue, 18 Aug 2015 13:36:27 -0400 (EDT)
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: "Vincent Olivier" <vincent@up4.com>
To: "Duncan" <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <1439520177.42462515@apps.rackspace.com>
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
 <pan$9bab3$33004c18$3a12cc04$86d0a7bb@cox.net>
 <1439520177.42462515@apps.rackspace.com>
Message-ID: <1439919387.128519934@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

it appears that it might be related to label/uuid fstab boot mounting instead

when I mount manually without the "noauto,x-systemd.automount” options and use the first device I get from "btrfs fi show" after a "btrfs device scan" I never get the problem

does this sound familiar ? I thought I was safe with uuid mount in stab…

I can (temporarily) live with manually mounting this filesystem but I would appreciate being able to mount it at boot time via fstab…

thanks

vincent

-----Original Message-----
From: "Vincent Olivier" <vincent@up4.com>
Sent: Thursday, August 13, 2015 22:42
To: "Duncan" <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory

I'll try without autodefrag anyways tomorrow just to make sure.

And then file a bug report too with however it decides to behave.

Vincent

-----Original Message-----
From: "Duncan" <1i5t5.duncan@cox.net>
Sent: Thursday, August 13, 2015 20:30
To: linux-btrfs@vger.kernel.org
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory

Chris Murphy posted on Thu, 13 Aug 2015 17:19:41 -0600 as excerpted:

> Well I think others have suggested 3000 snapshots and quite a few things
> will get very slow. But then also you have autodefrag and I forget the
> interaction of this with many snapshots since the snapshot aware defrag
> code was removed.

Autodefrag shouldn't have any snapshots mount-time-related interaction, 
with snapshot-aware-defrag disabled.  The interaction between defrag 
(auto or not) and snapshots will be additional data space usage, since 
with snapshot-aware disabled, defrag only works with the current copy, 
thus forcing it to COW the extents elsewhere while not freeing the old 
extents as they're still referenced by the snapshots, but it shouldn't 
affect mount-time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

