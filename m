Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51315 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3C2NGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:06:39 -0400
Message-ID: <515591D9.5010802@petaramesh.org>
Date: Fri, 29 Mar 2013 14:06:33 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
References: <515563D7.3020706@petaramesh.org> <20130329125832.GB1876@localhost.localdomain>
In-Reply-To: <20130329125832.GB1876@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Le 29/03/2013 13:58, Josef Bacik a écrit :
> So this is probably because of the extent tree corruption you had, it's just
> cleaning things up and you should be fine once it finishes.  Thanks,

Er... It's on a different machine !

Current (at the time I write) status is :

# btrfs scrub status /
scrub status for 346b81b2-0735-4c4d-a137-1995bc78ad70
        scrub resumed at Fri Mar 29 11:52:43 2013 and finished after
7470 seconds
        total bytes scrubbed: 231.96GB with 149691 errors
        error details: csum=149691
        corrected errors: 149691, uncorrectable errors: 0, unverified
errors: 0

I have to say that scrub completely froze the machine at least 4 times
(disk had ceased activity and any command that would imply a disk access
would hang forever), but at least after a (quite brutal) reboot it could
be resumed...

The only thing about this FS is that it had been imaged, then restored,
using partclone.btrfs (which itself is supposed to use the BTRFS libraries).

I have a screenshot of "last thing I saw when it hanged", I can upload
it somewhere, should it be relevant...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

