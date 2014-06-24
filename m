Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:44596 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaFXVvi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 17:51:38 -0400
Message-ID: <53A9F2F2.3030402@nv-systems.net>
Date: Tue, 24 Jun 2014 23:51:46 +0200
From: Gerald Hopf <gerald.hopf@nv-systems.net>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: "-d single" for data blocks on a multiple devices doesn't work
 as it should
References: <53A955F8.8090101@nv-systems.net> <pan$22dbe$42ad0785$2759193a$9b9beea1@cox.net>
In-Reply-To: <pan$22dbe$42ad0785$2759193a$9b9beea1@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 24.06.2014 13:45, Duncan wrote:
>> - not a single one (!) of the big files (3GB-15GB) survived
> A little familiarity with btrfs' chunk allocator and it's obvious what
> happened.  The critical point is that btrfs data chunks are 1 GiB in
> size, so files over a GiB will require multiple data chunks.  Meanwhile,
> from what I've read (I'm not an expert here but it does match what you
> saw), the chunk allocation algorithm allocates new chunks from the device
> with the most space left. [...] Thus allocation will be alternating, 1 GiB data from one, the next from the other.
Thanks for this excellent explanation. The benefits of using "single" 
(vs. raid0) seem a bit limited now with the only advantage for "single" 
now being that there is a good chance of recovering small files.

> Farther out, there has been discussion of adding additional chunk
> allocation schemes and making the choice configurable, which is really
> what you're asking for.  But while I think that's reasonably likely to
> eventually happen, I wouldn't expect to see it for a year at least, and
> honestly it's more likely two years out or more...
Looking forward to that happening one day. An simple allocator that just 
sequentially allocates each disk until full or some code that tries to 
make sure all data chunks for a file are on the same disk (given space 
is free) in "-d single" would be a cool feature that could provide "-d 
single" with a lot of benefit over btrfs-raid0 or LVM-Spanning. But I 
agree of course that probably way more people are interested in 
completion of the RAID5/6 code (me included!), so that's probably quite 
far out.

> ... Unless of course you happen to have sufficient interest in that
> feature to either code it up yourself if you have the skill, or (assuming
> you have the resources) sponsor someone who actually has the skill to do
> so.
I somehow have doubts that a complex filesystem is the right project for 
me to start learning C, so I'll have to pass :-) No huge corporation 
with that itch behind me either, and I guess it will be more than a few 
hours for a btrfs programmer so no way I could sponsor that on my own. 
Also, with Roman's excellent recommendation of mhddfs my itch has almost 
entirely disappeared

Thanks again for the quick response and the excellent explanation.
Gerald

