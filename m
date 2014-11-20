Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from milliways.jots.org ([198.204.250.45]:48512 "EHLO
	milliways.jots.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaKTSiT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 13:38:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Nov 2014 13:38:14 -0500
From: "Ken D'Ambrosio" <ken@jots.org>
To: Hugo Mills <hugo@carfax.org.uk>, "Ken D'Ambrosio" <ken@jots.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs send erroring...
In-Reply-To: <20141120171127.GM32735@carfax.org.uk>
References: <282a8749999cb6fed86f4ecd15152db0@webmail.jots.org>
 <20141120171127.GM32735@carfax.org.uk>
Message-ID: <a38424e6e09894e62772e256019939ea@webmail.jots.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-20 12:11, Hugo Mills wrote:
> On Thu, Nov 20, 2014 at 11:57:50AM -0500, Ken D'Ambrosio wrote:
>> Hi!  Trying to do a "btrfs send", and failing with:
>> 
>> root@khamul:~# btrfs send /biggie/BACKUP/ | btrfs receive /tmp/sdd1/
>> At subvol /biggie/BACKUP/
>> At subvol BACKUP
>> ERROR: rename o2046806-17126-0 -> volumes/ccdn-ch2-01 failed. No
>> such file or directory
> 
>    This looks like one of several bugs that have been fixed
> recently. What kernel version and userspace tools version are you
> using?

3.11...  older than I'd realized!  Guess it's time for an upgrade, eh?  
I'll give that a go -- thanks for the pointer!

-Ken
