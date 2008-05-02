From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 16:10:35 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805021609400.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <481A23AB.1020302@suse.com> <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr> <200805020852.51125.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
	kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2008-05-02 14:52, Chris Mason wrote:
>>
>> An alternative approach, and IMHO better suited, is to:
>>
>> 	make -C ${kdir} all I_HAZ_AN_APPARMOR=1
                       ^
                     M=$PWD

>This is better than the current situation (oops without any clues),

If it oopses, then you probably also get a compile-time warning on
that remove_suid line. And in that case, you can catch it with at least 
a compile-time typecheck so as to not make the user head straight into 
an oops, is not it?
