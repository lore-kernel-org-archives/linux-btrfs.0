Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i2.italiaonline.it ([212.48.25.194]:49678 "EHLO
	smtp-16.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164AbaLHOdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:33:10 -0500
Message-ID: <5485B6EB.1030101@inwind.it>
Date: Mon, 08 Dec 2014 15:34:19 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: ashford@whisperpc.com
CC: Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it>    <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>    <5484DC3C.7040409@inwind.it> <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
In-Reply-To: <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2014 01:12 AM, ashford@whisperpc.com wrote:
> Goffredo,
> 
>> So in case you have a raid1 filesystem on two disks; each disk has 300GB
>> free; which is the free space that you expected: 300GB or 600GB and why ?
> 
> You should see 300GB free.  That's what you'll see with RAID-1 with a
> hardware RAID controller, and with MD RAID.  Why would you expect to see
> anything else with BTRFS RAID?

I had to ask you because in a your previous email you stated something
different:

On 12/07/2014 09:32 PM, ashford@whisperpc.com wrote:
> I disagree.  My experiences with other file-systems, including ZFS, show
> that the most common solution is to just deliver to the user the actual
> amount of *unused disk space*
            ^^^^^^^^^^^^^^^^^^^

So I expected that you answered with 600GB. But you have told the true:
the user want to know how many data is able to store on the disk, and
not the unused disk space.

But I have to point out that the common case is one disk filesystem
where the metadata chunks have a ratio data stored/disk space 
consumed of 1:2; the data chunks have a ratio of 1:1. This is one
reason why is difficult to evaluate the free space: if you have
all metadata chunks, you have to half the disk space. 
Another reason is that there is the idea to allow different raid 
profiles in the same filesystem. This will further complicate the
free space evaluation.


> Peter Ashford

G.Baroncelli
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
