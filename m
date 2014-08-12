Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51336 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaHLEPm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 00:15:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XH3Uq-0008TR-61
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 06:15:40 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 06:15:40 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 06:15:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Tue, 12 Aug 2014 04:15:26 +0000 (UTC)
Message-ID: <pan$8f34b$65843f03$7e0dd88e$286fcd58@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
	<CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
	<pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
	<A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
	<CAETJ_S_YDnJsf9Fc6+ynpBVK7MXv3RGuhhJrSVV2Tizf1J+kdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jose Ildefonso Camargo Tolosa posted on Mon, 11 Aug 2014 16:33:36 -0500 as
excerpted:

> As I hate when a thread is left "hanging", you deserve to know what
> happened in the end, you likely already guessed, but anyway: I nuked the
> filesystem, and started over.
> 
> After some internal discussion in the company, we decided to move to ZFS
> for now.  However, we will keep an eye on btrfs, and will likely deploy
> it to some smaller system for further testing.
> 
> Thanks you all for your help!

Thank you too. =:^)

Sounds like a sane decision for the time being.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

