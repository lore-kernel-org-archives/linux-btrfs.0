Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51505 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaD3Am5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 20:42:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfIbw-0002WV-OL
	for linux-btrfs@vger.kernel.org; Wed, 30 Apr 2014 02:42:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 02:42:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 02:42:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Date: Wed, 30 Apr 2014 00:42:44 +0000 (UTC)
Message-ID: <pan$8e22f$932a091f$427154c$9f1ff63a@cox.net>
References: <cover.1398786620.git.dsterba@suse.cz>
	<pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
	<20140429171749.GI12281@merlins.org>
	<pan.2014.04.29.17.33.09@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Tue, 29 Apr 2014 17:33:09 +0000 as excerpted:

>> On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
>>> David Sterba posted on Tue, 29 Apr 2014 17:56:47 +0200 as excerpted:
>>> 
>>> > Changes:
>>> > * btrfs filesystem disk_usage - renamed to usage
>>> 
>>> [On the CLI, "usage" is often used to print a briefer "help",
>>> and thus shouldn't be used for an actual command.]
> 
> I think the point was to have the same term for both filesystem and
> device categories, which IMHO makes a lot of sense and is less to
> remember. Categorical polymorphism: it's a good thing. :)

Good idea to use the same term.

Bad idea (IMO) to make that term "usage", by itself.

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

