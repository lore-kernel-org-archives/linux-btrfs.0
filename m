Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-93.wadns.net ([196.220.39.93]:54802 "EHLO fw8a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751157Ab3JZJ2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 05:28:18 -0400
Message-ID: <526B8B1D.7090408@swiftspirit.co.za>
Date: Sat, 26 Oct 2013 11:27:57 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: lilofile <lilofile82@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid0 unable to mount
References: <CAC+R54CyxJXTZ=8va-30_0XDA9iNRr67mz=pT3MxysaCR+DFyw@mail.gmail.com>
In-Reply-To: <CAC+R54CyxJXTZ=8va-30_0XDA9iNRr67mz=pT3MxysaCR+DFyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/10/26 06:19 AM, lilofile wrote:
> when I use two disk to create raid0 in btrfs, after rebooting
> system,one disk unable to mount ,
> error is as follows:
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> in /var/log/kern.log
>
>   kernel: [  480.962487] btrfs: failed to read the system array on md0
>   kernel: [  480.988400] btrfs: open_ctree failed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
At first glance, this looks confusing since it is referring to md0, 
which would be md's raid.

Is it a btrfs-raid0 using an md-raid-something-else -> Or is it simply 
btrfs on top of an md-raid0?

     cat /proc/mdstat
and
     btrfs fi show
will answer those queries.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

