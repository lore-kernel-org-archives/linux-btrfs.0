Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54633 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3EGW2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 18:28:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZqMj-00027G-Ji
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 00:28:09 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 00:28:09 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 00:28:09 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Tue, 7 May 2013 22:27:54 +0000 (UTC)
Message-ID: <kmbv5a$all$2@ger.gmane.org>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
	<518973B2.4070308@gmail.com> <b0ao5a-81c.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 07 May 2013 23:58:08 +0200, Kai Krakow wrote:
> Gabriel de Perthuis <g2p.code@gmail.com> schrieb:
>>>   On the side note: dm-cache, which is already in-kernel, do not need to
>>> reformat backing storage.
>> 
>> On the other hand dm-cache is somewhat complex to assemble, and letting
>> the system automount the unsynchronised backing device is a recipe for
>> data loss.
> 
> Yes, that was my first impression, too, after reading of how it works. How 
> safe is bcache on that matter?

The bcache superblock is there just to prevent the naked backing device
from becoming available.  So it's safe in that respect.  LVM has
something similar with hidden volumes.

>> Anyway, here's a shameless plug for a tool that converts to bcache
>> in-place:  https://github.com/g2p/blocks#bcache-conversion
> 
> Did I say: I love your shameless plugs? ;-)
> 
> I've read the docs for this tool with interest. Still I do not feel very 
> comfortable with converting my storage for some unknown outcome. Sure, I can 
> take backups (and by any means: I will). But it takes time: backup, try, 
> restore, try again, maybe restore... I don't want to find out that it was 
> all useless because it's just not ready to boot a multi-device btrfs through 
> dracut. So you see, the point is: Will that work? I didn't see any docs 
> answering my questions.

Try it with a throwaway filesystem inside a VM.  The bcache list will
appreciate the feedback on Dracut, even if you don't make the switch
for real.

> Of course, if it would work I'd happily contribute documentation to your 
> project.

That would be very welcome.


