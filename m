From: Chris Ball <cjb@laptop.org>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Thu, 18 Nov 2010 00:15:11 -0500
Message-ID: <m3r5ejyzz4.fsf@pullcord.laptop.org>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Brian Sullivan <bexamous@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
	(Brian Sullivan's message of "Wed, 17 Nov 2010 21:03:02 -0800")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Is doesn't return, I check top and both ls and flush-btrfs-1 are
   > sitting at ~50% sys usage each.

Does anything new appear in dmesg when the hang happens?  Can you run
alt-sysrq-t (show tasks) and send us the output for the ls process?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
