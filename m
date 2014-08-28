Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51320 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaH1RaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 13:30:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XN3WN-0001rN-Jo
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 19:30:03 +0200
Received: from 11.161.185.203.dsl.dyn.mana.pf ([203.185.161.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 19:30:03 +0200
Received: from jd.girard by 11.161.185.203.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 19:30:03 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Undelete files / directory
Date: Thu, 28 Aug 2014 07:04:55 -1000
Message-ID: <ltnnfo$a57$1@ger.gmane.org>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for your detailed answer.

Le 28/08/2014 06:25, Chris Murphy a écrit :
> 9. btrfs-find-root /dev/sdc
> Super think's the tree root is at 29917184, chunk root 20987904
> Well block 4194304 seems great, but generation doesn't match, have=2, want=9 level 0
> Well block 4243456 seems great, but generation doesn't match, have=3, want=9 level 0
> Well block 29376512 seems great, but generation doesn't match, have=4, want=9 level 0
> Well block 29474816 seems great, but generation doesn't match, have=5, want=9 level 0
> Well block 29556736 seems great, but generation doesn't match, have=6, want=9 level 0
> Well block 29736960 seems great, but generation doesn't match, have=7, want=9 level 0
> Well block 29900800 seems great, but generation doesn't match, have=8, want=9 level 0

Here is what the command returns :

[root@x220 ~]# btrfs-find-root /dev/mapper/home
Super think's the tree root is at 115230801920, chunk root 131072
Went past the fs size, exiting[root@x220 ~]#

I just tried with latest btrfs-progs (from git), it returns exactly the
same.

The btrfs partition is on top of dm-crypt, could it be a problem?


Thanks,
Jean-Denis Girard

