Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaFDNPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 09:15:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WsB2A-0002Vc-94
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 15:15:14 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 15:15:14 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 15:15:14 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: What to do about snapshot-aware defrag
Date: Wed, 04 Jun 2014 14:15:01 +0100
Message-ID: <lmn64l$s0g$1@ger.gmane.org>
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org> <538C7A79.8070407@fb.com> <lmln77$ee0$1@ger.gmane.org> <m49fvjlghh2.fsf@coffee.modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <m49fvjlghh2.fsf@coffee.modeemi.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/06/14 10:19, Erkki Seppala wrote:
> Martin <m_btrfs@ml1.co.uk> writes:
> 
>> The *ONLY* application that I know of that uses atime is Mutt and then
>> *only* for mbox files!...
> 
> However, users, such as myself :), can be interested in when a certain
> file has been last accessed. With snapshots I can even get an idea of
> all the times the file has been accessed.
> 
>> *And go KISS and move on faster* better?
> 
> Well, it in uncertain to me if it truly is better that btrfs would after
> that point no longer truly even support atime, if using it results in
> blowing up snapshot sizes. They might at that point even consider just
> using LVM2 snapshots (shudder) ;).

Not quite... My emphasis is:


1:

Go KISS for the defrag and accept that any atime use will render the
defrag ineffective. Give a note that the noatime mount option should be
used.


2:

Consider using noatime as a /default/ being as there are no known
'must-use' use cases. Those users still wanting atime can add that as a
mount option with the note that atime use reduces the snapshot defrag
effectiveness.


(The "for/against atime" is a good subject for another thread!)


Go fast KISS!

Regards,
Martin



