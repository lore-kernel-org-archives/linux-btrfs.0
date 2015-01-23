Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:48075 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbbAWKCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 05:02:10 -0500
Subject: RE: Recovery Operation With Multiple Devices
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?Hugo_Mills?= <hugo@carfax.org.uk>
Cc: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Fri, 23 Jan 2015 21:02:08 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.54c21c20.5659.1e1fe25438614d4e@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----Original message-----
From:	Hugo Mills <hugo@carfax.org.uk>
Sent:	Fri 01-23-2015 08:48 pm
Subject:	Re: Recovery Operation With Multiple Devices
Attachment:	signature.asc
To:	Brett King <brett.king@commandict.com.au>; 
CC:	linux-btrfs@vger.kernel.org; 
> On Fri, Jan 23, 2015 at 06:53:42PM +1100, Brett King wrote:
> > Hi All,
> > Just wondering how 'btrfs recovery' operates, when the source device given is 
> one of many in an MD array - I can't find anything documentation beyond a 
> single device use case.
> > 
> > Does it automatically include all devices in the relevant MD array as occurs 
> when mounting, or does it only restore the data which happened to be written to 
> the specific, single device given ?
> 
>    Neither. :)
> 
>    It automatically includes all devices as occurs when running
> btrfsck.

Fantastic - that is very powerful and exactly what I need.

 OK, it's a relatively pointless distinction, but the
> mechanisms are slightly different.
> 
> > From an inverse perspective, how can I restore all data including snapshots, 
> which are spread across a damaged MD FS to a new (MD) FS ?
> 
>    btrfs restore -l will show you the list of tree roots, which (for
> trees numbered 256 and up) correspond to subvolumes and snapshots. You
> can then use -r to select the tree to restore.

Great info, will keep that in the tool box !

> 
> > Can send / receive do this perhaps ?
> 
>    Yes, but only if you can mount the FS.
> 
>    Hugo.

Excellent, much appreciated.

> 
> -- 
> Hugo Mills             | I know of three kinds: hot, cool, and
> hugo@... carfax.org.uk | what-time-does-the-tune-start?
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |                                          Chris Dollin
>
