From: Adrian - <phaet0n@hotmail.com>
Subject: Adding to multi-device raid filesystems
Date: Fri, 11 Jun 2010 00:28:33 -0400
Message-ID: <COL103-W3834C74893F4923C5FF86F9D90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Dear all,



What raid policy does a subsequent balance operation follow

when adding a new device to an existing -d raid0 filesystem

initially created on two devices? What if the initial creation

was raid1?



In particular, if I have two 1TB drives that I initially stripe,

can I subsequently mirror them onto a 2TB drive that I add

later on? Can I recover if any single drive fails?



Thank you.
 		 	   		  
_________________________________________________________________
Look 'em in the eye: FREE Messenger video chat
http://go.microsoft.com/?linkid=9734386