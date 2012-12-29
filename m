Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18343 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752083Ab2L2Lai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 06:30:38 -0500
Received: from 165.105.77.188.dynamic.jazztel.es ([188.77.105.165] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1Toucd-000L42-BS
	for linux-btrfs@vger.kernel.org; Sat, 29 Dec 2012 11:30:35 +0000
Date: Sat, 29 Dec 2012 12:30:30 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: ENOSPC, while 18GB are unallocated
Message-ID: <20121229113030.GA12338@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a fs with those free space parameters in a 3.6.6 arm system:
from 'btrfs fi show':
Total devices 1 FS bytes used 70.38GB
devid    1 size 111.29GB used 93.14GB path /dev/sda1

from 'btrfs fi df /':
Data: total=87.01GB, used=68.29GB
Metadata, DUP: total=3.00GB, used=2.09GB

And I get ENOSPC on unlink, ENOSPC on balance (-dusage=5 -musage=5 even), ENOSPC
truncating files to size 0, ...

The numbers show that there are ~18GB *unallocated*, isn't it? Why do I have any
ENOSPC?

In fact, although 'truncate' reports "couldn't truncate: ENOSPC", further 'ls
-l' show the file became 0-bytes long.

I could exit this deadlock situation thanks to 'btrfs fi defrag a_directory'.
But I reach ENOSPC soon again.

It would be very nice, if ENOSPC wrote a line in the kernel log stating the
cause of ENOSPC. The kernel log, in this case, didn't report much other than
"btrfs: 19 enospc during balance".

Regards,
Lluís.
