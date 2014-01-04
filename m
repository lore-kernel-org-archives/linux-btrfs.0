Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60643 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbaADOv3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 09:51:29 -0500
From: Chris Mason <clm@fb.com>
To: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 4 Jan 2014 14:51:23 +0000
Message-ID: <1388847120.23513.21.camel@ret.masoncoding.com>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>
	 <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>
	 <52C74415.3020407@jrs-s.net>
	 <7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
	 <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
In-Reply-To: <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2014-01-04 at 06:10 +-0000, Duncan wrote:
+AD4- Chris Murphy posted on Fri, 03 Jan 2014 16:22:44 -0700 as excerpted:
+AD4- 
+AD4- +AD4- I would not make this option persistent by putting it permanently in the
+AD4- +AD4- grub.cfg+ADs- although I don't know the consequence of always mounting with
+AD4- +AD4- degraded even if not necessary it could have some negative effects (?)
+AD4- 
+AD4- Degraded only actually does anything if it's actually needed.  On a 
+AD4- normal array it'll be a NOOP, so should be entirely safe for /normal/ 
+AD4- operation, but that doesn't mean I'd /recommend/ it for normal operation, 
+AD4- since it bypasses checks that are there for a reason, thus silently 
+AD4- bypassing information that an admin needs to know before he boots it 
+AD4- anyway, in ordered to recover.
+AD4- 

+AD4- However, I've some other comments to add:
+AD4- 
+AD4- 1) As you I'm uncomfortable with the whole idea of adding degraded 
+AD4- permanently at this point.
+AD4- 

I added mount -o degraded just because I wanted the admin to be notified
of failures.  Right now it's still the most reliable way to notify them,
but I definitely agree we can do better.  Leaving it on all the time?  I
don't think this is a great long term solution, unless you are actively
monitoring the system to make sure there are no failures.

Also, as Neil Brown pointed out it does put you at risk of transient
device detection failures getting things out of sync.

+AD4- Test:  
+AD4- 
+AD4- a) Create a two device btrfs raid1.
+AD4- 
+AD4- b) Mount it and write some data to it.
+AD4- 
+AD4- c) Unmount it, unplug one device, mount degraded the remaining device.
+AD4- 
+AD4- d) Write some data to a test file on it, noting the path/filename and 
+AD4- data.
+AD4- 
+AD4- e) Unmount again, switch plugged devices so the formerly unplugged one is 
+AD4- now the plugged one, and again mount degraded.
+AD4- 
+AD4- f) Write some DIFFERENT data to the SAME path/file as in (d), so the two 
+AD4- versions each on its own device have now incompatibly forked.
+AD4- 
+AD4- g) Unmount, plug both devices in and mount, now undegraded.
+AD4- 
+AD4- What I discovered back then, and to my knowledge the same behavior exists 
+AD4- today, is that entirely unexpectedly from and in contrast to my mdraid 
+AD4- experience, THE FILESYSTEM MOUNTED WITHOUT PROTEST+ACEAIQ-
+AD4- 
+AD4- h) I checked the file and one variant as written was returned.  STILL NO 
+AD4- WARNING+ACE-  While I didn't test it, I'm assuming based on the PID-based 
+AD4- round-robin read-assignment that I now know btrfs uses, that which copy I 
+AD4- got would depend on whether the PID of the reading thread was even or 
+AD4- odd, as that's what determines what device of the pair is read.  (There 
+AD4- has actually been some discussion of that as it's not a particularly 
+AD4- intelligent balancing scheme and it's on the list to change, but the 
+AD4- current even/odd works well enough for an initial implementation while 
+AD4- the filesystem remains under development.)
+AD4- 
+AD4- i) Were I rerunning the test today, I'd try a scrub and see what it did 
+AD4- with the difference.  But I was early enough in my btrfs learning that I 
+AD4- didn't know to run it at that point, so didn't do so.  I'd still be 
+AD4- interested in how it handled that, tho based on what I know of btrfs 
+AD4- behavior in general, I can /predict/ that which copy it'd scrub out and 
+AD4- which it would keep, would again depend on the PID of the scrub thread, 
+AD4- since both copies would appear valid (would verify against their checksum 
+AD4- on the same device) when read, and it's only when matched against the 
+AD4- other that a problem, presumably with the other copy, would be detected.
+AD4- 

It'll pick the latest generation number and use that one as the one true
source.  For the others you'll get crc errors which make it fall back to
the latest one.  If the two have exactly the same generation number,
we'll have a hard time picking the best one.

Ilya has a series of changes from this year's GSOC that we need to clean
up and integrate.  It detects offline devices and brings them up to date
automatically.

He targeted the pull-one-drive use case explicitly.

-chris

