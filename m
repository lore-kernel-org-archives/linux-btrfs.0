Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51965 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbaKSQfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 11:35:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xr8Df-0004db-4H
	for linux-btrfs@vger.kernel.org; Wed, 19 Nov 2014 17:35:03 +0100
Received: from 213.47.207.20 ([213.47.207.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 17:35:03 +0100
Received: from wertstoffe by 213.47.207.20 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 17:35:03 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
Subject: btrfs send and an existing backup
Date: Wed, 19 Nov 2014 16:58:16 +0100
Message-ID: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

I'm new on btrfs, and I like it :)

But i have a question. I have a existing backup on an external HDD. This 
was ext4 before i converted it to btrfs.
And i installed my debian new on btrfs with some subvolumes. (f.e. home, 
var, multimedia/Video multimedia/Audio...)

On my backup there are no subvolumes.

Now i wrote a script to take local snapshots on my laptops HDD an mirror 
this snapshots with btrfs send/receive to the external HDD.

An i don't know, how to do, to make the inital snapshot on the external 
HDD. I want to use the existing data there, so I don't have to transmit 
the whole bunch of data to the external drive, which exists there 
already...

What happens, if i make the same structure on the external drive with 
creating subvolumes and »cp --reflink«, give this subvolumes the correct 
names, and fire a »btrfs send«?

Or is the best (ONLY???) way, to make an initial snapshot on the 
external drive and delete the old backup there?

greetings
jakob

-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

