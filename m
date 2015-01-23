Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-dovie.wadns.net ([41.185.62.186]:37922 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbbAWOdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 09:33:31 -0500
Message-ID: <54C25BAB.50102@swiftspirit.co.za>
Date: Fri, 23 Jan 2015 16:33:15 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Matthias Urlichs <matthias@urlichs.de>, linux-btrfs@vger.kernel.org
Subject: Re: "btrfs send" and interrupts
References: <20150123095846.GC26830@smurf.noris.de>
In-Reply-To: <20150123095846.GC26830@smurf.noris.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/23 11:58, Matthias Urlichs wrote:
> Hi,
>
> root@data:/daten/backup/email/xmit# btrfs send foo | ssh wherever btrfs receive /mnt/mail/xmit/
> At subvol foo
> At subvol foo
> [ some time passes and I need to do something else on that volume ]
>
> ^Z
> [1]+  Stopped                 btrfs send foo | ssh -p50022 surf btrfs receive /mnt/mail/xmit/
> root@data:/daten/backup/email/xmit# bg
> [1]+ btrfs send foo | ssh -p50022 surf btrfs receive /mnt/mail/xmit/ &
> root@data:/daten/backup/email/xmit#
> [ Immediately afterwards, this happens: ]
>
> ERROR: crc32 mismatch in command.
>
> At subvol foo
>
> At subvol foo
> ERROR: creating subvolume foo failed. File exists
> [1]+  Exit 1                  btrfs send foo | ssh -p50022 surf btrfs receive /mnt/mail/xmit/
> root@data:/daten/backup/email/xmit#
>
> Yowch. Please make sure that the simple act of backgrounding a data
> transfer doesn't abort it. That was ten hours in, now I have to repeat
> the whole thing. :-/
>
> Thank you.
Interesting case. I'm not sure of the merits/workaround needed to do 
this. It appears even using cat into netcat (nc) causes netcat to quit 
if you background the operation.

A workaround for future: I *strongly* recommend using screen for 
long-lived operations. This would have avoided the problem. Perhaps you 
were sitting in front of the server and it wasn't much of a concern at 
the time - but most admins work remotely. Never mind ^z, what about 
other occurrences such as if the power/internet goes out at your 
office/home and the server is on another continent? Your session dies 
and you lose 10 hours of work/waiting. With a screen session, that is no 
longer true.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

