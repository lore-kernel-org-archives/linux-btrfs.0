Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:53886 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2J0WKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 18:10:04 -0400
Received: from yeono.kjorling.se (c-1717e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.23.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id C4348B914008
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 22:09:41 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id 48AAC47E2B6
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 00:09:41 +0200 (CEST)
Date: Sat, 27 Oct 2012 22:09:40 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs behave on checksum mismatch?
Message-ID: <20121027220940.GV2381@yeono.kjorling.se>
References: <20121027215645.GU2381@yeono.kjorling.se>
 <20121027220215.GA5042@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121027220215.GA5042@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 Oct 2012 23:02 +0100, from hugo@carfax.org.uk (Hugo Mills):
>> I came across the tidbit that ZFS has a contract guarantee that the
>> data read back will either be correct (the checksum computed over the
>> data read from the disk matches the checksum stored on disk), or you
>> get an I/O error. Obviously, this greatly reduces the probability that
>> the data is invalid. (Particularly when taken in combination with the
>> disk firmware's own ECC and checksumming.)
>> 
>> With the default options, does btrfs make any similar guarantees? If
>> not, then are there any options to force it to make such guarantees?
> 
>    It does indeed do the same thing: if the checksum doesn't match the
> block, then the alternative block is read (if one exists, e.g. RAID-1,
> RAID-10). If that does not exist, or also has a checksum failure, then
> EIO is returned.

Great!

This should perhaps be mentioned more clearly in the Wiki.

Also, thanks for the prompt reply.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
