Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36827 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755986Ab3L3QBb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 11:01:31 -0500
From: Chris Mason <clm@fb.com>
To: "lists@colorremedies.com" <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>
Subject: Re: systemd-journal, nodatacow, was: Is anyone using btrfs
 send/receive for backups instead of rsync?
Date: Mon, 30 Dec 2013 16:00:53 +0000
Message-ID: <1388419281.11341.4.camel@ret.masoncoding.com>
References: <20131228171943.GE19863@merlins.org>
	 <20131228173730.GA7234@carfax.org.uk>
	 <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
	 <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
	 <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
	 <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
	 <EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
	 <pan$ac557$b59f1c0a$eeb339c8$e2df444@cox.net>
	 <9B8C24F7-2F6C-4879-9A21-6A6D940BE4C1@colorremedies.com>
In-Reply-To: <9B8C24F7-2F6C-4879-9A21-6A6D940BE4C1@colorremedies.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2013-12-29 at 17:38 -0700, Chris Murphy wrote:
+AD4- On Dec 29, 2013, at 5:39 AM, Duncan +ADw-1i5t5.duncan+AEA-cox.net+AD4- wrote:
+AD4- 
+AD4- +AD4- Yes, it does turn off checksumming as well as COW, but given the write-
+AD4- +AD4- into scenario, that's actually best anyway, because otherwise btrfs has 
+AD4- +AD4- to keep updating the checksums
+AD4- 
+AD4- On second thought, I'm less concerned with bitrot and checksumming being lost with nodatacow, than I am with significantly increasing the chance the journal is irreparably lost due to corruption during an unclean shutdown.

So first, send/receive +- nowcow aren't a great combination.  NOCOW won't
update the generation numbers send/receive needs to find changes.  The
best send/receive can do in that case is send over the entire file.

+AD4- 
+AD4- +AD4- But in all these cases, it's also quite common for the application doing 
+AD4- +AD4- the writing to have its own checksumming/error-detection and possible 
+AD4- +AD4- correction -- it pretty much comes with the territory -- in which case 
+AD4- +AD4- btrfs attempting to do the same is simply superfluous even if it weren't 
+AD4- +AD4- a race-condition trigger.
+AD4- 
+AD4- I don't know what kind of checksumming systemd performs on the journal, but whenever Btrfs has found corruption with the journal file(s), systemd-journald has also found corruption and starts a new log. So it makes sense to rely on its own mechanisms, than Btrfs's.
+AD4- 

The autodefrag mode was really made for the small databases like
systemd.  I'd prefer that we use that for systemd instead of suggesting
NOCOW.  I'm finally dusting off my work to improve db performance, so
hopefully we can do much better in the near future.

-chris

