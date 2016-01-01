Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37435 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbcAAKoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 05:44:08 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: still kworker at 100% cpu in all of device size allocated with chunks situations with write load
Date: Fri, 01 Jan 2016 11:44:06 +0100
Message-ID: <8251866.lvEs5v0muB@merkaba>
In-Reply-To: <5670BC6D.1010906@cn.fujitsu.com>
References: <8336788.myI8ELqtIK@merkaba> <20151215215958.GC6322@ret.masoncoding.com> <5670BC6D.1010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First: Happy New Year to you!

Second: Take your time. I know its holidays for many. For me it means I easily 
have time to follow-up on this.

Am Mittwoch, 16. Dezember 2015, 09:20:45 CET schrieb Qu Wenruo:
> Chris Mason wrote on 2015/12/15 16:59 -0500:
> > On Mon, Dec 14, 2015 at 10:08:16AM +0800, Qu Wenruo wrote:
> >> Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
> >>> Hi!
> >>> 
> >>> For me it is still not production ready.
> >> 
> >> Yes, this is the *FACT* and not everyone has a good reason to deny it.
> >> 
> >>> Again I ran into:
> >>> 
> >>> btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
> >>> random write into big file
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=90401
> >> 
> >> Not sure about guideline for other fs, but it will attract more dev's
> >> attention if it can be posted to maillist.
> >> 
> >>> No matter whether SLES 12 uses it as default for root, no matter whether
> >>> Fujitsu and Facebook use it: I will not let this onto any customer
> >>> machine
> >>> without lots and lots of underprovisioning and rigorous free space
> >>> monitoring. Actually I will renew my recommendations in my trainings to
> >>> be careful with BTRFS.
> >>> 
> >>>  From my experience the monitoring would check for:
> >>> merkaba:~> btrfs fi show /home
> >>> Label: 'home'  uuid: […]
> >>> 
> >>>          Total devices 2 FS bytes used 156.31GiB
> >>>          devid    1 size 170.00GiB used 164.13GiB path
> >>>          /dev/mapper/msata-home
> >>>          devid    2 size 170.00GiB used 164.13GiB path
> >>>          /dev/mapper/sata-home
> >>> 
> >>> If "used" is same as "size" then make big fat alarm. It is not
> >>> sufficient for it to happen. It can run for quite some time just fine
> >>> without any issues, but I never have seen a kworker thread using 100%
> >>> of one core for extended period of time blocking everything else on the
> >>> fs without this condition being met.>> 
> >> And specially advice on the device size from myself:
> >> Don't use devices over 100G but less than 500G.
> >> Over 100G will leads btrfs to use big chunks, where data chunks can be at
> >> most 10G and metadata to be 1G.
> >> 
> >> I have seen a lot of users with about 100~200G device, and hit unbalanced
> >> chunk allocation (10G data chunk easily takes the last available space
> >> and
> >> makes later metadata no where to store)
> > 
> > Maybe we should tune things so the size of the chunk is based on the
> > space remaining instead of the total space?
> 
> Submitted such patch before.
> David pointed out that such behavior will cause a lot of small
> fragmented chunks at last several GB.
> Which may make balance behavior not as predictable as before.
> 
> 
> At least, we can just change the current 10% chunk size limit to 5% to
> make such problem less easier to trigger.
> It's a simple and easy solution.
> 
> Another cause of the problem is, we understated the chunk size change
> for fs at the borderline of big chunk.
> 
> For 99G, its chunk size limit is 1G, and it needs 99 data chunks to
> fully cover the fs.
> But for 100G, it only needs 10 chunks to covert the fs.
> And it need to be 990G to match the number again.
> 
> The sudden drop of chunk number is the root cause.
> 
> So we'd better reconsider both the big chunk size limit and chunk size
> limit to find a balanaced solution for it.

Did you come to any conclusion here? Is there anything I can change with my 
home BTRFS filesystem to try to find out what works? Challenge here is that it 
doesn´t happen under defined circumstances. So far I only know the required 
condition, but not the sufficient condition for it to happen.

Another user run into the issue and reported his findings in the bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=90401#c14

Thanks,
-- 
Martin
