Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:33343 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754210AbaEERHq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 13:07:46 -0400
Message-ID: <5367C551.6020604@swiftspirit.co.za>
Date: Mon, 05 May 2014 19:07:29 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Please review and comment, dealing with btrfs full issues
References: <20140505121603.GO10159@merlins.org>
In-Reply-To: <20140505121603.GO10159@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/14 14:16, Marc MERLIN wrote:
> I've just written this new page:
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>
> First, are there problems in it?
>
> Second, are there other FS full issues I should mention in it?
>
> Thanks,
> Marc
"In the case above, because the filesystem is only 55% full, I can ask 
balance to rewrite all chunks that are more than 55% full:

legolas:~# btrfs balance start -dusage=50 /mnt/btrfs_pool1"

"-dusage=50" will balance all chunks that are 50% *or less* used, not 
more. The idea is that full chunks are better left alone while emptyish 
chunks are bundled together to make new full chunks, leaving big open 
areas for new chunks. Your process is good however - just the 
explanation that needs the tweak. :)

In your last example, a full rebalance is not necessary. If you want to 
clear all unnecessary chunks you can run the balance with -dusage=80 
(636GB/800GB~=79%). That will cause a rebalance only of the data chunks 
that are 80% and less used, which would by necessity get about ~160GB 
worth chunks back out of data and available for re-use.

The issue I'm not sure of how to get through is if you can't balance 
*because* of ENOSPC errors. I'd probably start scouring the mailing list 
archives if I ever come across that.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

