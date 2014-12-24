Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53058 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaLXDwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 22:52:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y3d0F-00063d-Ez
	for linux-btrfs@vger.kernel.org; Wed, 24 Dec 2014 04:52:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 04:52:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 04:52:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Quota limit question
Date: Wed, 24 Dec 2014 03:52:41 +0000 (UTC)
Message-ID: <pan$2d7ff$776cb5c$1da18373$20ae4371@cox.net>
References: <20141217011537.GA1114@anthem.async.com.br>
	<20141223203601.GB30477@async.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Robottom Reis posted on Tue, 23 Dec 2014 18:36:02 -0200 as
excerpted:

> On Tue, Dec 16, 2014 at 11:15:37PM -0200, Christian Robottom Reis wrote:
>>     # btrfs qgroup limit 2000m 0/261 . && touch x touch: cannot touch
>>     ‘x’: Disk quota exceeded
>> 
>> The strange thing is that it doesn't seem to be actually out of space:
>> 
>>     # btrfs qgroup show -p -r -e /var | grep 261
>>     0/261    1111810048  391114752   2097152000  0          ---
> 
> Replying to myself as I had not yet been subscribed in time to receive a
> reply; I just upgraded to 3.18.1 and am seeing the same issue on the
> same subvolume (and on no others).

Looking at the thread here on gmane.org (list2news and list2web gateway), 
it appears my reply was the only reply in any case, and it was general as 
I don't run quotas myself.

Basically I suggested upgrading, as the quota code as some rather huge 
bugs in it (quotas could go seriously negative!) with the old versions 
you were running.  But you've upgraded at least the kernel now (userspace 
you didn't say).

Here's a link to the thread on the gmane web interface for completeness, 
but the above about covers my reply, as I said the only one until your 
thread bump and my reply here, so there's not much new there unless 
someone posts further followups to this thread...


http://comments.gmane.org/gmane.comp.file-systems.btrfs/41491


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

