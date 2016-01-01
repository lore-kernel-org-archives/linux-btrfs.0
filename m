Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41024 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbcAAI6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 03:58:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEvXm-0002sx-LV
	for linux-btrfs@vger.kernel.org; Fri, 01 Jan 2016 09:58:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 09:58:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 09:58:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send clone use case
Date: Fri, 1 Jan 2016 08:58:31 +0000 (UTC)
Message-ID: <pan$5e659$256039e4$4fae854f$8723618d@cox.net>
References: <CAJCQCtR03dZ7ErDsYox4kaxFsNapxxNLxFiN9R0qSMSdp0-_hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 31 Dec 2015 13:54:42 -0700 as excerpted:

> I haven't previously heard of this use case for -c option.
> It seems to work (no errors or fs weirdness afterward).
> 
> The gist:
> send a snapshot from drive 1 to drive 2;
> rw snapshot of the drive 2 copy,
> and then make changes to it,
> then make an ro snapshot;
> now send it back to drive 1 *as an incremental* send.

While as you likely know my own use-case doesn't use send/receive, based 
on previous on-list discussion, I considered this the obvious workaround 
to the problem of the current send stream format not including enough 
inheritance metadata to allow send/receive to properly handle a /reverse/ 
send -p.

Where -p works, it's the most efficient method, but due to this lack of 
send-stream inheritance metadata, it apparently can't work in the reverse 
case, where the usual receive end is now the send end.

But doing -c clones, while not /quite/ as efficient as -p because more 
metadata is sent, is still far more efficient than doing a full send, and 
can work in this reverse case where the original send side is now the 
receive side because it's not as strict as -p, being rather more metadata 
verbose in place of that strictness, where the -p option would fail due 
to strictness and lack of appropriate inheritance metadata in the stream 
format.

That -p mode missing inheritance metadata, being effectively just one 
more item, would still be much more efficient than using -c clones, as 
the clone format is generally more metadata-verbose in ordered to 
properly identify per-extent clones, but it's simply not there in the 
current format.  When the send format is eventually version-bumped, this 
additional metadata item should be included, making send -p work in these 
reverse-send cases, but they ideally want to do just one more "final"
send-stream format bump including all changes they've found to be needed, 
so they're holding off on the format bump for the moment, so as to be 
able to include anything else they've overlooked when they do finally do 
it.

That's as I understand the state of send/receive, anyway, being 
interested in it on-list, but not being a current user.  But this usage 
of -c being almost precisely that "reverse-send" usage, only with an 
additional change thrown in at the normal receive side before the send, 
I'd actually have been surprised if it /didn't/ work as you outlined. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

