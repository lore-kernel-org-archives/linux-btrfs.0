Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58816 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3C2NMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:12:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DBD1C7C0680
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 07:12:20 -0600 (MDT)
Date: Fri, 29 Mar 2013 09:12:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
Message-ID: <20130329131218.GC1876@localhost.localdomain>
References: <515563D7.3020706@petaramesh.org>
 <20130329125832.GB1876@localhost.localdomain>
 <515591D9.5010802@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <515591D9.5010802@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 29, 2013 at 07:06:33AM -0600, Swâmi Petaramesh wrote:
> Hi Josef,
> 
> Le 29/03/2013 13:58, Josef Bacik a écrit :
> > So this is probably because of the extent tree corruption you had, it's just
> > cleaning things up and you should be fine once it finishes.  Thanks,
> 
> Er... It's on a different machine !
> 
> Current (at the time I write) status is :
> 
> # btrfs scrub status /
> scrub status for 346b81b2-0735-4c4d-a137-1995bc78ad70
>         scrub resumed at Fri Mar 29 11:52:43 2013 and finished after
> 7470 seconds
>         total bytes scrubbed: 231.96GB with 149691 errors
>         error details: csum=149691
>         corrected errors: 149691, uncorrectable errors: 0, unverified
> errors: 0
> 
> I have to say that scrub completely froze the machine at least 4 times
> (disk had ceased activity and any command that would imply a disk access
> would hang forever), but at least after a (quite brutal) reboot it could
> be resumed...
> 
> The only thing about this FS is that it had been imaged, then restored,
> using partclone.btrfs (which itself is supposed to use the BTRFS libraries).
> 

This is where I go "AHA!" and just assume that it wasn't our fault ;).

> I have a screenshot of "last thing I saw when it hanged", I can upload
> it somewhere, should it be relevant...
> 

Screenshots are welcome, I have no doubt scrub is fixing actual problems, but it
definitely shouldn't be hanging the box so I'd like to get those fixed if
possible.  Sysrq+w during hangs are very usefull but may be too much output for
screenshots, netconsole works very nicely for this

http://fedoraproject.org/wiki/Netconsole

Thanks,

Josef
