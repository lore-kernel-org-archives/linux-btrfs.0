Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40267 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab3EIXg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 May 2013 19:36:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UaaNt-0003Oq-7F
	for linux-btrfs@vger.kernel.org; Fri, 10 May 2013 01:36:25 +0200
Received: from dyndsl-178-142-090-237.ewe-ip-backbone.de ([178.142.90.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 01:36:25 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-090-237.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 01:36:25 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
Date: Fri, 10 May 2013 01:30:14 +0200
Message-ID: <15ot5a-f1m.ln1@hurikhan.ath.cx>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net> <ch7o5a-g0b.ln1@hurikhan.ath.cx> <7jio5a-b5g.ln1@hurikhan.ath.cx> <518A318A.7060105@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:

>> Apparently, it's not fixed. The system does not freeze now but it threw
>> multiple backtraces right in front of my Xorg session. The backtraces
>> look a little bit different now. Here's what I got:
>> 
>> https://gist.github.com/kakra/8a340f006d01e146865d
>> 
>> Occurence while running "bedup dedup --defrag --size-cutoff
>> $((1024*1024))" which was currently dedup'ing my backup volume with daily
>> snapshots filled by "rsync --inplace" - so I suppose some file contents
>> are pretty scattered.
> 
> At least that looks different for now. I'm not certain about all the fixes
> in btrfs-next. Can you give it a try and bisect if btrfs-next is good?
> That would be really helpful.

I'd prefer to not bisect my production system kernel... That will probably 
take ages as running the "reproducable test" takes about 30-60 minutes 
before the problem hits my system. At least unless you had a suggestion how 
to speed up the process... ;-)

I saw the pull request with those fixes, so I supsect it didn't go into 
3.9.1 but rather will go into 3.9.2?

I probably wait and just do not run the dedup process until I have 3.9.2 
installed. The backup works with occassional hiccups, the system very very 
sometimes freezes but I almost always see the backtraces in dmesg after 
backup. Let's see if it's all gone in 3.9.2.

Regards,
Kai

