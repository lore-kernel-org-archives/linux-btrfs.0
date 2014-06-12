Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:55895 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaFLLNn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 07:13:43 -0400
Message-ID: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
Date: Thu, 12 Jun 2014 13:13:26 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <david@fromorbit.com>
Subject: R: Re: Slow startup of systemd-journal on BTRFS
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Da: david@fromorbit.com
>Data: 12/06/2014 3.21
>A: <kreijack@inwind.it>
>Cc: "systemd Mailing List"<systemd-devel@lists.freedesktop.org>, "linux-btrfs"
<linux-btrfs@vger.kernel.org>
>Ogg: Re: Slow startup of systemd-journal on BTRFS
>
>On Wed, Jun 11, 2014 at 11:28:54PM +0200, Goffredo Baroncelli wrote:
>> Hi all,
>> 
>> I would like to share a my experience about a slowness of systemd when used 
on BTRFS.
>> 
>> My boot time was very high (about ~50 seconds); most of time it was due to 
NetworkManager which took about 30-40 seconds to start (this data came from 
"systemd-analyze plot").
>> 
>> I make several attempts to address this issue. Also I noticed that sometime 
this problem disappeared; but I was never able to understand why.
>> 
>> However this link
>> 
>> 	https://bugzilla.redhat.com/show_bug.cgi?id=1006386
>> 
>> suggested me that the problem could be due to a bad interaction between 
systemd and btrfs. NetworkManager was innocent. 
>
>systemd has a very stupid journal write pattern. It checks if there
>is space in the file for the write, and if not it fallocates the
>small amount of space it needs (it does *4 byte* fallocate calls!)
>and then does the write to it.  All this does is fragment the crap
>out of the log files because the filesystems cannot optimise the
>allocation patterns.

I checked the code, and to me it seems that the fallocate() are
done in FILE_SIZE_INCREASE unit (actually 8MB). 

>
>Yup, it fragments journal files on XFS, too.
>
>http://oss.sgi.com/archives/xfs/2014-03/msg00322.html
>
>IIRC, the systemd developers consider this a filesystem problem and
>so refused to change the systemd code to be nice to the filesystem
>allocators, even though they don't actually need to use fallocate...

If I am able to start a decent setup I would like to play to change some
parameters like:
- remove fallocate at all (at the beginning only ?)
- increase the fallocate allocation unit
- change the file log size and rotation time
- periodically defragment
[...[
>
>Cheers,
>
>Dave.
>
>-- 
>Dave Chinner
>david@fromorbit.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


