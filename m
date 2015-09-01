Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:39908 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbbIARbr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 13:31:47 -0400
Date: Tue, 1 Sep 2015 13:31:46 -0400 (EDT)
Subject: Re: errors while "btrfs receive"
From: "Vincent Olivier" <vincent@up4.com>
To: "Duncan" <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <pan$e8554$6dbe382c$ff1dc29$3d51b79e@cox.net>
References: <1441046042.49932584@apps.rackspace.com>
 <pan$e8554$6dbe382c$ff1dc29$3d51b79e@cox.net>
Message-ID: <1441128706.141824093@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's ~900GiB. Sorry.

I'm on 4.1.6 Arch Linux.

-----Original Message-----
From: "Duncan" <1i5t5.duncan@cox.net>
Sent: Tuesday, September 1, 2015 03:30
To: linux-btrfs@vger.kernel.org
Subject: Re: errors while "btrfs receive"

Vincent Olivier posted on Mon, 31 Aug 2015 14:34:02 -0400 as excerpted:

> i'm doing a ~900TiB receive on a 6x4TB RAID0
> 
> "fi show", "device scan" all fail and report "unable to connect to
> /dev/sdX"
> 
> is it normal ?

Can't answer your direct question as my use-case doesn't include send/
receive, but...

~900TiB receive on a 24TB (6x4TB) raid0?  

Did you mean ~900GiB, or did you miss the decimal point, or ????  I mean, 
yeah, btrfs does have the compress= option, but I don't think it's going 
to compress 900 TiB to fit in under 24!  That's likely to be some 
seriously lossy compression!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

