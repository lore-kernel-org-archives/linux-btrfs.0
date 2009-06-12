From: Michael Raskin <a0091f122@rambler.ru>
Subject: Re: cleanup after a small data loss on incorrect shutdown.
Date: Fri, 12 Jun 2009 22:52:57 +0400
Message-ID: <4A32A409.3030208@rambler.ru>
References: <4A30FC2E.3030804@rambler.ru> <20090612105332.GG3834@think> <4A32374A.6080900@rambler.ru> <20090612114230.GH3834@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Michael Raskin <a0091f122@rambler.ru>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090612114230.GH3834@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
>> That's all. Reading one of the damaged file actually returned
>> "Input/output error" - probably it tried to read beyond end-of-device. I
>>  had to kill this file (practical testing means that to continue to use
>> my notebook normally I had to nuke the damaged file and get intact
>> copies). The "no such file except in readdir" is still there right now.
> 
> Ok, btrfsck will give us more output when it finishes, but it hasn't
> finished.  It would help to use btrfs-image to send us a coyp of the
> metadata so we can fix the btrfsck bug.

I have a 74M compressed btrfs-image of a partition with a ghost file (I
sent btrfsck logs earlier). Would they be of any use in debugging
handling of such situations? If yes - how should I transmit the image
file? How can I kill the ghost file?
