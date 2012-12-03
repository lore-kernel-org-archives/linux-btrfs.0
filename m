Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:53742 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2LCPzv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 10:55:51 -0500
Message-ID: <50BCCB85.9010905@jan-o-sch.net>
Date: Mon, 03 Dec 2012 16:55:49 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
References: <50BC92F6.6050404@petaramesh.org>
In-Reply-To: <50BC92F6.6050404@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Swâmi,

On Mon, December 03, 2012 at 12:54 (+0100), Swâmi Petaramesh wrote:
> Hi folks,
> 
> My laptop is a Core i3-2310M with 4 GB RAM, running BTRFS on a 1 TB HD.
> 
> I run Ubuntu 12.10 Quantal, kernel 3.5.0-19-generic 64-bit.
> 
> I wanted to give a shot at bitcoin so I installed it from the Ubuntu
> PPA, and started getting the database from the Internet. (it's now 4.5
> GB big on disk). I assume it an SQL DB (SQlite or so ?)
> 
> My system currently has been crushing its data for more that 5 days now
> (5x24 hours) with the HD busy to the point that the system is completely
> unusable and I had to take another laptop to be able to surf the web and
> process my email. Disk LED is steadily lit, trying to switch between 2
> open windows takes 5 minutes or so...
> 
> Entering new blocks into the DB has now slowed down to the point that I
> assume that the last 6% that I miss (I'm now at 94.something %) may well
> take another couple weeks or so...
> 
> Friends running ext4 told me that the initial loading of the DB took
> them a couple hours... With BTRFS it's been 5x24 hours and counting... :-(

I've experienced exactly the same as you have with btrfs, only with ext4 instead
of btrfs: Use ubuntu (which in the default setup means you're using ecryptfs for
your /home), install the bitcoin package (which puts its files in ~/.bitcoin)
and the computer becomes very much unresponsive once bitcoin is fetching data
blocks.

Unresponsive here means that even the desktop clock misses to count a second
here and then, the mouse pointer stops reacting. Haven't looked further into
this, but I suspect ecryptfs isn't completely innocent in that stack. That said,
I suggest trying to make an ext4 partition on the very same hardware, setup
ecryptfs, mount it as ~/.bitcoin and share your findings :-)

Besides that, as Hugo told you, you can disable btrfs cow on the database files,
but given my experiences I wouldn't put too much hope into that part.

-Jan
