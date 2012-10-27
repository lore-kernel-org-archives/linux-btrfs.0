Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:53755 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab2J0V5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 17:57:10 -0400
Received: from yeono.kjorling.se (c-1717e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.23.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id 45DFFB914008
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 21:56:47 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id CF3A647E2B6
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 23:56:46 +0200 (CEST)
Date: Sat, 27 Oct 2012 21:56:45 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: How does btrfs behave on checksum mismatch?
Message-ID: <20121027215645.GU2381@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I came across the tidbit that ZFS has a contract guarantee that the
data read back will either be correct (the checksum computed over the
data read from the disk matches the checksum stored on disk), or you
get an I/O error. Obviously, this greatly reduces the probability that
the data is invalid. (Particularly when taken in combination with the
disk firmware's own ECC and checksumming.)

With the default options, does btrfs make any similar guarantees? If
not, then are there any options to force it to make such guarantees?

I'm interested in this both from a specification and an implementation
point of view.

The last thing anyone wants is probably undetected bit rot, and with
today's large drives, even with the quite low bit rot numbers it can
be a real concern. If even the act of simply successfully reading a
file guarantees, to the extent of the checksumming algorithm's ability
to detect changes, that the data read is the same as was once written,
that would be a major selling point for btrfs for me personally.

The closest I was able to find was that btrfs uses crc32c currently
for data and metadata checksumming and that this can be turned off if
so desired (using the "nodatasum" mount option), but nothing about
what the file system code does or is supposed to do in the face of a
checksum mismatch.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
