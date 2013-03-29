Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58880 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab3C2N0G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:26:06 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 87E297C0680
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 07:26:06 -0600 (MDT)
Date: Fri, 29 Mar 2013 09:26:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
Message-ID: <20130329132603.GD1876@localhost.localdomain>
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
> I have a screenshot of "last thing I saw when it hanged", I can upload
> it somewhere, should it be relevant...
> 

Actually instead of netconsole we have an awesome service provided by Carey, you
can just do

nc cwillu.com 10101 < /dev/kmsg

after you've run sysrq+w and then reply with the URL it spits out.  Thanks,

Josef
