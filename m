Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42293 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaL0Ddy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 22:33:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y4i8V-0001Wa-7X
	for linux-btrfs@vger.kernel.org; Sat, 27 Dec 2014 04:33:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 04:33:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 04:33:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 03:33:39 +0000 (UTC)
Message-ID: <pan$3ccf$2dcccc1c$e1a118c$5c6b699b@cox.net>
References: <3738341.y7uRQFcLJH@merkaba> <3207071.8ytD2jQS28@merkaba>
	<1790464.sXlqaAlXiG@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Fri, 26 Dec 2014 15:41:23 +0100 as excerpted:

> Am Freitag, 26. Dezember 2014, 15:20:42 schrieben Sie:
>> And I wonder about:
>> > Martin 'Helios' Steigerwald - http://www.Lichtvoll.de GPG: 03B0 0D6C
>> > 0040 0710 4AFA  B82F 991B EAAC A599
>> >
>> >
>> > 
>> 
> 84C7N�����r��y����b�X��ǧv�^�)޺{.n�+����{�n�߲)����w*jg��������ݢj/
���z�ޖ��2
>> 
>> > �ޙ����&�)ߡ�a�����G���h��j:+v���w��٥
>> 
>> These random chars are not supposed to be there: I better run scrub
>> straight  after this balance.
> 
> Okay, thats not me I think. scrub didn´t report any errors and when I
> look in kmail send folder I don´t see these random chars as well, so it
> seems some server on the wire added the garbage.

FWIW...

They didn't show up here on gmane's list2nntp service (message viewed 
with pan), either.  There were a few strange characters -- your dashes(?) 
on either side of the "are these a problem?" showed up as the squares 
containing four digits (0080, 0093) that appear when a font doesn't 
contain the appropriate character it's being asked to display, and there 
were a few others, but that's a common charset/font l10n issue, not the 
apparent line noise binary corruption shown above.

So I'd guess it was either the transmission to your mail service, at the 
mail service, or the transmission between them and your mail client, that 
corrupted.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

