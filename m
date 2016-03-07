Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42717 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbcCGPNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 10:13:30 -0500
Received: from [12.139.153.2] (port=50204 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1acwqf-0002kI-Jp by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 07:13:29 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1acwqe-0005bf-I9
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 07:13:28 -0800
Date: Mon, 7 Mar 2016 07:13:28 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Documentation for BTRFS error (device dev): bdev /dev/xx errs:
 wr 22, rd 0, flush 0, corrupt 0, gen 0
Message-ID: <20160307151328.GF29369@merlins.org>
References: <20160223215911.GA13811@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160223215911.GA13811@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 01:59:11PM -0800, Marc MERLIN wrote:
> I have a freshly created md5 array, with drives that I specifically
> scanned one by one block by block, and for good measure, I also scanned
> the entire software raid with a check command which took 3 days to run.
> 
> Everything passed.
> 
> Then, I made a bcache of that device, an ssd that seems to work fine
> otherwise (brand new), and dmcrypted the result
> 
> md5 - bache - dmcrypt - btrfs
> ssd /
> 
> Now, I'm copying data over with btrfs send, and I'm seeing these slowly
> show up and the write counter go up one by one.
> BTRFS error (device dm-7): bdev /dev/mapper/oldds1 errs: wr 17, rd 0, flush 0, corrupt 0, gen 0
> 
> Where is the documentation for those counters?
> Is the write error fatal, or a recovered error?
> Should I consider that my filesystem is corrupted as soon as any of
> those counters go up?
> (I couldn't find an exact meaning of each of them)
> 

Sadly, this problem hasn't gone away
[ 2381.333412] BTRFS error (device dm-5): bdev /dev/mapper/oldds1 errs: wr 298, rd 0, flush 0, corrupt 0, gen 0

I'm really trying to make sense out of it.
Are those recovered errors (bad IO, command was retried, things worked
after that), fatal errors (data loss)

That md5 is in a disk shelf at the end of a longish esata cable. It's
possible that the cable is bad, or it couuld be something else entirely.
I'm still trying to understand the error so that I can diagnose and
address it properly.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
