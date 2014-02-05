Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60037 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaBESX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 13:23:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WB785-00077F-0o
	for linux-btrfs@vger.kernel.org; Wed, 05 Feb 2014 19:23:21 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 19:23:21 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 19:23:21 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Wed, 05 Feb 2014 19:17:10 +0100
Message-ID: <6qbasa-fq1.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> schrieb:

> On Tue, Feb 04, 2014 at 08:22:05PM -0500, Josef Bacik wrote:
>> On 02/04/2014 03:52 PM, Kai Krakow wrote:
>> >Hi!
>> >
>> >I'm curious... The whole snapshot thing on btrfs is based on its COW
>> >design. But you can make individual files and directory contents nocow
>> >by applying the C attribute on it using chattr. This is usually
>> >recommended for database files and VM images. So far, so good...
>> >
>> >But what happens to such files when they are part of a snapshot? Do they
>> >become duplicated during the snapshot? Do they become unshared (as a
>> >whole) when written to? Or when the the parent snapshot becomes deleted?
>> >Or maybe the nocow attribute is just ignored after a snapshot was taken?
>> >
>> >After all they are nocow and thus would be handled in another way when
>> >snapshotted.
>> >
>> When snapshotted nocow files fallback to normal cow behaviour.
> 
> This may seem unclear to people not familiar with the actual
> implementation, and I had to think for a second about that sentence. The
> file will keep the NOCOW status, but any modified blocks will be newly
> allocated on the first write (in a COW manner), then the block location
> will not change anymore (unlike ordinary COW).

Ah okay, that makes it clear. So, actually, in the snapshot the file is 
still nocow - just for the exception that blocks being written to become 
unshared and relocated. This may introduce a lot of fragmentation but it 
won't become worse when rewriting the same blocks over and over again.

> HTH

Yes, it does. ;-)

-- 
Replies to list only preferred.

