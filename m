Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47945 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750892AbaH1UVI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 16:21:08 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Undelete files / directory
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <ltnnfo$a57$1@ger.gmane.org>
Date: Thu, 28 Aug 2014 14:21:03 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <883EA056-F115-4254-9412-622C07170707@colorremedies.com>
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

Doubtful.

What do you get for 

btrfs-debug-tree -R /dev/sdc

Under each listed "btrfs root backup slot" is a line for tree root block with a generation and a block number listed. Good chance the generation with the highest value will not contain your file; or any generation more than 30 seconds from the time of the deletion. But since it's a read only command you can't really mess it up, just try each of those tree root block values in reverse (descending) order for the btrfs restore -t value.

Obviously you should not mount the volume rw.


Chris Murphy