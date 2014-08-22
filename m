Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50891 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVRfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 13:35:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKske-0007aA-DM
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 19:35:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 19:35:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 19:35:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Significance of high number of mails on this list?
Date: Fri, 22 Aug 2014 17:35:36 +0000 (UTC)
Message-ID: <pan$b0f07$6c9be711$e76b466$99de97dd@cox.net>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
	<2217061.yFV10mnZWq@merkaba>
	<CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
	<53F6E9B7.1040701@gmail.com>
	<pan$258d1$c3749601$d83e6a85$e56acf7f@cox.net>
	<CAL3q7H6PrjdSA-qjEsiX6vEMQbeYukn2R4vh=f4mteQNv0Y_qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe David Manana posted on Fri, 22 Aug 2014 10:58:33 +0100 as
excerpted:

> On Fri, Aug 22, 2014 at 8:35 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Konstantinos Skarlatos posted on Fri, 22 Aug 2014 09:56:55 +0300 as
>> excerpted:
>>
>>> I would stay with rsync for a while, because there is always the
>>> possibility of a bug [...] (Or maybe I am too paranoid[)]
>>
>> I believe in this case you /are/ "being too paranoid."
>>
>> Both btrfs send and receive only deal with data/metadata they know how
>> to deal with.  If it's corrupt in some way or if they don't understand
>> it, they don't send/write it, they fail.
> 
> Most of the time yes, however we have at least 1 know bug that affects
> 3.14.x only where send silently corrupts file data (replaces valid data
> with zeroes) at the destination:
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/
commit/?id=766b5e5ae78dd04a93a275690a49e23d7dcb1f39
> 
> The fix landed in 3.15, but wasn't backported to 3.14.x yet (adding
> Chris to cc).
> 
> 
>> IOW, if it works without error it's as guaranteed to be golden as these
>> things get.

Well, I /did/ say "as golden as these things get".  With even long stable 
subsystems such as mdraid having occasional data-risking bugs, and with 
btrfs in general not yet fully stable/mature...

But point taken.  That bug flew under my radar.  Thanks for mentioning it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

