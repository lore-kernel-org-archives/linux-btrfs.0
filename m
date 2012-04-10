From: Leho Kraav <leho@kraav.com>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Tue, 10 Apr 2012 18:31:57 +0300
Message-ID: <4F84526D.1070207@kraav.com>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com> <4F82F5BA.3080504@kraav.com> <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com> <4F834D75.5060703@kraav.com> <4F835550.6090106@kraav.com> <20120409231954.GC11041@twin.jikos.cz> <20120410090718.GA2345@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Daniel J Blueman <daniel@quora.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410090718.GA2345@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On 10.04.2012 12:07, Ilya Dryomov wrote:
 > On Tue, Apr 10, 2012 at 01:19:54AM +0200, David Sterba wrote:
 >>
 >> IIRC somebody reported similar problem recently. It basically means
 >> there's an inconsistent balance state. Adding Ilya to CC.
 >
 > Leho, so you just mount with discard patch and run 'btrfs fi balance
 > <mnt>', correct ?
 >
 > The problem is that you have balance state on disk (from trying to run
 > balance earlier w/o discard patch) but we are failing to pick it up on
 > mount.
 >
 > Could you please post the entire dmesg and the output of
 > 'btrfs-debug-tree -d<dev>' somewhere ?
 >
 > Could you also apply the debug patch below, mount your fs and send me
 > dmesg output (no need to run balance, just mount) ?
 >

Your understanding of situation based on above is correct.

Yes I can do all the stuff, but it's going to take until next week, 
since I'm travelling and I can't risk BUG-ing my server remotely.
