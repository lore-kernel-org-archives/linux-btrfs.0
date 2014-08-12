Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:55822 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaHLQ5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 12:57:10 -0400
Received: from [212.23.1.5] (helo=smarthost01c.mail.zen.net.uk)
	by queue01b.mail.zen.net.uk with esmtp (Exim 4.72)
	(envelope-from <david@chrestomanci.org>)
	id 1XHEPd-0001rS-Ul
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 15:55:01 +0000
Received: from [82.70.68.182] (helo=www.chrestomanci.org)
	by smarthost01c.mail.zen.net.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <david@chrestomanci.org>)
	id 1XHENf-0009BG-Vv
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 15:53:00 +0000
Message-ID: <53EA3852.2000607@chrestomanci.org>
Date: Tue, 12 Aug 2014 16:52:50 +0100
From: David Pottage <david@chrestomanci.org>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, Vimal A R <arvimal@yahoo.in>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com>
In-Reply-To: <53E83035.8010603@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 11/08/14 03:53, Austin S Hemmelgarn wrote:

> Another thing that isn't listed there, that I would personally love to
> see is support for secure file deletion.  To be truly secure though,
> this would need to hook into the COW logic so that files marked for
> secure deletion can't be reflinked (maybe make the automatically NOCOW
> instead, and don't allow snapshots?), and when they get written to, the
> blocks that get COW'ed have the old block overwritten.
How would secure deletion interact with file de-duplication?

For example suppose you and I are both users on a multi user system. We 
both obtain copies of the same file independently, and save that file to 
our home directories.

A background process notices that both files are the same and 
de-duplicates them. This means that both your file and mine point to the 
same blocks on disc. This is exactly the same as would happen if you 
made a COW copy of your file, transferred ownership to me, and I moved 
it into my home dir.

You then decide to secure delete your copy of the file. What happens to 
mine? If it gets removed, then you have just deleted a file you don't 
own, if it does not then the file-system has broken the contract to 
secure delete a file when you asked it to.

Also, what happens if the two files have similar portions, but they are 
not identical. For example, if you download and ISO image for ubuntu, 
and I download the ISO for kubuntu (at the same version). There will be 
a lot of sections that are the same, because they will contain a lot of 
packages in common, so there will be large gains in de-duplicating the 
similar parts, but most people would consider the files to be different.

Could this mean that if you secure delete your ubuntu iso, then portions 
of my kubuntu iso might become corrupt?

Even if we limit secure delete to root, then we still leave the risk of 
unintentonaly breaking user files, because non-one realised that all or 
part of the file appears in other files via de-duplication. In any case 
if secure delete is limited to root, then most people would not find it 
useful. (or they would use sudo to do it, which brings us back to the 
same problems).

Basically, I think that file secure deletion as a concept is not 
compatible with a 5th generation file system. If you relay want to 
securely remove a file, then copy the stuff you need elsewhere, and put 
the disc in the crusher. Alternatively put the filesystem in an encypted 
container, and then reformat the disc with a different encryption key.

-- 
David Pottage.











