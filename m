Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41494 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3C0UwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 16:52:16 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7EE867C0682
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 14:52:16 -0600 (MDT)
Date: Wed, 27 Mar 2013 16:52:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130327205212.GM28030@localhost.localdomain>
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

BTW if the fsck doesn't fix your problem don't despair, I'm hacking up another
option for btrfs-image to just walk the trees themselves and scrape everything
so I can have a full image from you and then I'll be able to fix fsck to fix
your file system.  Thanks,

Josef
