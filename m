From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 15:30:05 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805021526420.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <481A23AB.1020302@suse.com> <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr> <200805020852.51125.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
	kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2008-05-02 14:52, Chris Mason wrote:
>>
>> An alternative approach, and IMHO better suited, is to:
>>
>> 	make -C ${kdir} all I_HAZ_AN_APPARMOR=1
>
>This is better than the current situation (oops without any clues), but I'd 
>prefer that people not have to know what apparmor is or if they have it.  

I guess iff people have a clue just what btrfs is and what it is good for
and why one would need it, I guess they also know of Apparmor.
If not, well, I hope you mentioned it in the INSTALL file!
Documentation on the most important things is always a good thing.

>(This isn't a knock on apparmor, I'd just rather take care of it 
>automagically).

Well you could go down the conftest.sh route, but I dislike that
approach because such a Makefile system tries to be smarter than me;
and that often breaks because developers made a mess out of the
remaining Makefile and before long, it broke on odd, but
"standards-conforming", O= builds. (Fun stories with nvidia.)
