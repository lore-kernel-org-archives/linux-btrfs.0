Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48993 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaHVETn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 00:19:43 -0400
Date: Thu, 21 Aug 2014 21:19:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Significance of high number of mails on this list?
Message-ID: <20140822041937.GI3875@merlins.org>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
 <2217061.yFV10mnZWq@merkaba>
 <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 09:10:55AM +0530, Shriramana Sharma wrote:
> Hello people. Thank you for your detailed replies, esp Duncan.
> 
> In essence, I plan on using BTRFS for my production data -- mainly
> programs/documents I write in connection with my academic research.
> I'm not a professional sysadmin and I'm not running a business server.
> I'm just managing my own data, and as I have mentioned, my chief
> reason for looking at BTRFS is the ease of snapshots and backups using
> send/receive.
> 
> It is clear now that snapshots are by and large stable but
> send/receive is not. But, IIUC, even if send/receive fails I still

I wouldn't quite agree with that, btrfs send/receive has been working
fairly well for me on multiple systems for multiple backups per day.
My laptop oftens fails to complete a btrfs send to my server remotely
over the internet, and it recovers on its own a the next cron run and
sends the a newer bigger diff next time and it just works.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
