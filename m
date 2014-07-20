Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:35509 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGTOAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 10:00:49 -0400
Date: Sun, 20 Jul 2014 16:00:44 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Message-ID: <20140720140044.GB7469@mother.pipebreaker.pl>
References: <loom.20140720T102642-239@post.gmane.org>
 <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 20, 2014 at 01:53:34PM +0000, Duncan wrote:
> TM posted on Sun, 20 Jul 2014 08:45:51 +0000 as excerpted:
> 
> > One week for a raid10 rebuild 4x3TB drives is a very long time.
> > Any thoughts?
> > Can you share any statistics from your RAID10 rebuilds?
> 
> 
> At a week, that's nearly 5 MiB per second, which isn't great, but isn't 
> entirely out of the realm of reason either, given all the processing it's 
> doing.  A day would be 33.11+, reasonable thruput for a straight copy, 
> and a raid rebuild is rather more complex than a straight copy, so...

  Uhm, sorry, but 5MBps is _entirely_ unreasonable.  It is order-of-magnitude
unreasonable.  And "all the processing" shouldn't even show as a blip
on modern CPUs.
  This "speed" is undefendable.

-- 
Tomasz Torcz               RIP is irrevelant. Spoofing is futile.
xmpp: zdzichubg@chrome.pl     Your routes will be aggreggated. -- Alex Yuriev

