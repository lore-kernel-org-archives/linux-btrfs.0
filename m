Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:41396 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753329AbaLGXAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 18:00:08 -0500
Message-ID: <5484DC3C.7040409@inwind.it>
Date: Mon, 08 Dec 2014 00:01:16 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: ashford@whisperpc.com
CC: Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it> <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
In-Reply-To: <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/07/2014 09:32 PM, ashford@whisperpc.com wrote:
>> In conclusion, the disk usage is well known; which is unknown is
>> > the space that is available to the user (who is uninterested to
>> > all the details inside a filesystem). The best that is doable
>> > is an estimation like the above one.

> I disagree.  My experiences with other file-systems, including ZFS, show
> that the most common solution is to just deliver to the user the actual
> amount of unused disk space.  Anything else changes this known value into
> a guess or prediction.

So in case you have a raid1 filesystem on two disks; each disk has 300GB
free; which is the free space that you expected: 300GB or 600GB and why ?


> 
> Peter Ashford

BR
G.Baroncelli
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
