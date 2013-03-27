Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41316 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3C0UjO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 16:39:14 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0DCAD7C0682
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 14:39:14 -0600 (MDT)
Date: Wed, 27 Mar 2013 16:39:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130327203911.GL28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130327183325.GK28030@localhost.localdomain>
 <CAAr69zaQ22_SLg4sfUkDE=NBNTAUaSr9ZgaL=sTPJ-kvXkFRug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zaQ22_SLg4sfUkDE=NBNTAUaSr9ZgaL=sTPJ-kvXkFRug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 01:17:56PM -0600, Szőts Ákos wrote:
> I ran two different versions of btrfsck on the partition.
> 
> The first one was shipped with openSUSE 12.3, kernel 3.7.
> This is the original tool with which the partition was checked:
> http://paste.opensuse.org/74569620
> 
> The second one is from your tree (maybe it's newer):
> http://filebin.ca/bfbwJezYwCV/btrfsck-v2.txt
> 

Ok so I'm still having some weird issues restoring your image and I wonder if
they are because of the extent tree corruption.  So it looks like you had some
extent tree corruption and you are just unluckily getting hit because the free
space inode is trying to write to an area that has csums but no extent.  So can
you do

btrfsck --repair

using the btrfsck from my tree (you may have to do it a few times to clear
everything out) and then see if that fixes the problem for you?  Thanks,

Josef
