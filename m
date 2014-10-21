Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:33219 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074AbaJUQkX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 12:40:23 -0400
Message-ID: <54468C73.1070108@inwind.it>
Date: Tue, 21 Oct 2014 18:40:19 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au>	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>	<54454858.8010802@pobox.com> <54456EB0.9020503@inwind.it> <pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
In-Reply-To: <pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/2014 11:50 AM, Duncan wrote:
> Goffredo Baroncelli posted on Mon, 20 Oct 2014 22:21:04 +0200 as
> excerpted:
> 
[...]
>> > 
>> > Could this be related to the inode overflow in 32 bit system (see
>> > inode_cache options) ? If so running a 64bit "ls -i" should work....
> Good point.  Russell might just owe you a beverage of choice.  =:^)
> 
> The inode_cache mount option isn't recommended for any bitness.


Hi Ducan, 
could you elaborate this sentence ? From my understanding 
inode_cache is *needed* on 32bit system in order to avoid inode number
overflow. Why are you saying that it is not recommended ?
Even if there are bugs, these have to be corrected. A bugs cannot be
a reason to remove a needed option.

Inode exhaustion is worse than a slowness... Otherwise BTRFS would be not
suitable to a 32 bit system... But please tell me your opinion because may 
be I misunderstood something... 

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
