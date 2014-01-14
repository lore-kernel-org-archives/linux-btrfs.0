Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:40479 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbaANV1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:27:47 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0ELRjcx009081
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 16:27:45 -0500
Message-ID: <52D5ABE9.6040008@chinilu.com>
Date: Tue, 14 Jan 2014 13:28:09 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>	<52CF4D5D.2010709@chinilu.com>	<486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>	<52D59E28.7010200@chinilu.com> <20140115030021.0b001eeb@natsu>
In-Reply-To: <20140115030021.0b001eeb@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2014 01:00 PM, Roman Mamedov wrote:
> On Tue, 14 Jan 2014 12:29:28 -0800
> George Mitchell <george@chinilu.com> wrote:
>
>> what we are lacking at this point is a SMART capability to provide
>> visual notifications to the user when any hard drive starts to seriously
>> degrade or suddenly fails.
> You can configure smartd (from smartmontools) to send you E-Mails on any
> change of the monitored SMART attributes.
Well, sorry, email is nice, but it doesn't work for me as a desktop 
user.  1) I don't want to have to hand configure and email system like 
sendmail to generate outgoing emails.  2) I don't want to have to go 
through and hand configure /etc/smartd/conf.  3) I don't want my email 
clogged up with SMART messages.
>
>> If SMART were capable of launching pop up warnings
> And I'm sure there are a number of GUI tools out there for just about any OS,
> which can do just that
Really?  And for Linux they are?  I know it can be done because various 
administrative tools provided by my distro routinely flash up status 
notices on my screen.  I really like that.  It lets my know what my 
system is doing.  journalctl provides red type warnings when a drive is 
failing.  That should be thrown up on the screen and stay there till I 
dismiss it.  To me thats a no brainer.
>
>> btrfs would not have to worry so much about arrays going simplex undetected.
> That said, do not fall into a false sense of security relying on proprietary,
> barely if ever updated after the device has been shipped, and often very
> peculiar-behaving SMART routines inside the black-box HDD firmware as your
> most important data safeguard.
>
> Of course SMART must be checked and monitored, but don't delude yourself into
> thinking it will always warn you of anything going wrong well in advance of
> failure, or even at all.

Well, since I began using SMART I have had a total of two drive failures 
so far and both of them generated warnings and the drives in question 
were still operating normally when I disgarded them. Plenty of 
opportunity to retrieve the data and wipe the drives.  I'm sure SMART 
does fail advance notifictation in some instances, but even when it 
does, at least it will certainly warn me IMMEDIATELY that the drive is 
gone after the fact.
>

