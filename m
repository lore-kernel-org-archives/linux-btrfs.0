Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39910 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751383AbaH1Va4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 17:30:56 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Undelete files / directory
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <ltnnfo$a57$1@ger.gmane.org>
Date: Thu, 28 Aug 2014 15:30:53 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2E882BA1-E572-4B5B-9AC7-B5B2CD40920B@colorremedies.com>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com> <ltnnfo$a57$1@ger.gmane.org>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 28, 2014, at 11:04 AM, Jean-Denis Girard <jd.girard@sysnux.pf> wrote:

> Hi Chris,
> 
> Thanks for your detailed answer.
> 
> Le 28/08/2014 06:25, Chris Murphy a écrit :
>> 9. btrfs-find-root /dev/sdc
>> Super think's the tree root is at 29917184, chunk root 20987904
>> Well block 4194304 seems great, but generation doesn't match, have=2, want=9 level 0
>> Well block 4243456 seems great, but generation doesn't match, have=3, want=9 level 0
>> Well block 29376512 seems great, but generation doesn't match, have=4, want=9 level 0
>> Well block 29474816 seems great, but generation doesn't match, have=5, want=9 level 0
>> Well block 29556736 seems great, but generation doesn't match, have=6, want=9 level 0
>> Well block 29736960 seems great, but generation doesn't match, have=7, want=9 level 0
>> Well block 29900800 seems great, but generation doesn't match, have=8, want=9 level 0
> 
> Here is what the command returns :
> 
> [root@x220 ~]# btrfs-find-root /dev/mapper/home
> Super think's the tree root is at 115230801920, chunk root 131072
> Went past the fs size, exiting[root@x220 ~]#
> 
> I just tried with latest btrfs-progs (from git), it returns exactly the
> same.
> 
> The btrfs partition is on top of dm-crypt, could it be a problem?

So I'm working with a really rudimentary case here. However, this might also be possible:

# btrfs-show-super /dev/sdc
[snip]
generation		11
[snip]

That's the current generation at unmount time. If nothing at all was being written to the volume between delete time and unmount time, the generation you want will be one less than this.

Then you can use, for example:

# btrfs-debug-tree -g 10 /dev/sdc

And that'll hopefully return a tree block for that generation. In my case it wouldn't be good news because I had already had several remounts, so the generation had rolled over a few times since I'd deleted the file so it's not in generation 10, or even generation 8. So I tried generation 7 again where I found it before:

# btrfs-find-root -g 7 /dev/sdc
Super think's the tree root is at 29491200, chunk root 20987904
Well block 4194304 seems great, but generation doesn't match, have=2, want=7 level 0
Well block 4243456 seems great, but generation doesn't match, have=3, want=7 level 0
Well block 29409280 seems great, but generation doesn't match, have=10, want=7 level 0
Well block 29491200 seems great, but generation doesn't match, have=11, want=7 level 0
Well block 29556736 seems great, but generation doesn't match, have=6, want=7 level 0

Unfortunately there's no gen 7. So I'm not sure how to discover the tree block number.

I still have it written down from before of course, and it still works:

btrfs restore -v -t 29736960 /dev/sdc /home/chris/
parent transid verify failed on 29736960 wanted 12 found 7
parent transid verify failed on 29736960 wanted 12 found 7
parent transid verify failed on 29736960 wanted 12 found 7
parent transid verify failed on 29736960 wanted 12 found 7
Ignoring transid failure
Restoring /home/chris/pics
Restoring /home/chris/pics/IMG_3327.tif
Done searching /pics
Done searching 


The shasum for this file though doesn't match the original. Size is correct though. But it doesn't open, application says it's corrupted. So it might take some work to recover that, if even possible. So I'd definitely say (again) don't mount the volume rw. And hopefully nothing was written between directory delete time and unmount time.


Chris Murphy


