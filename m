From: Chris Ball <cjb@laptop.org>
Subject: Re: kernel BUG
Date: Thu, 23 Dec 2010 19:51:47 -0500
Message-ID: <m38vzg3sd8.fsf@pullcord.laptop.org>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org> <20101223215500.4f177913@simplux>
	<m3d3os3tuz.fsf@pullcord.laptop.org> <20101224013224.43c0f9b3@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101224013224.43c0f9b3@simplux> (Michael Niederle's message of
	"Fri, 24 Dec 2010 01:32:24 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Currently I'm running with -rc7. If the system still runs
   > tomorrow morning I will do another test with -rc5 - this time on
   > the USB 3.0 port. This should show whether this is a hardware or
   > software problem.

Thanks, sounds good.  Yes, the location of the BUG() does suggest a
hardware problem, assuming it's coded correctly.  dmesg would tell us
for sure, because the I/O error would be reported above the BUG()
output.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
