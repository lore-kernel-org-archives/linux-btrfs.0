Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:61299 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920Ab3JIRRs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Oct 2013 13:17:48 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't move subvols into subvols
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131009162706.GG16461@localhost.localdomain>
Date: Wed, 9 Oct 2013 11:17:43 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <03A8C5A5-6E1D-45EC-9B1A-D0F144003580@colorremedies.com>
References: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com> <20131009162706.GG16461@localhost.localdomain>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 9, 2013, at 10:27 AM, Josef Bacik <jbacik@fusionio.com> wrote:

> On Tue, Oct 08, 2013 at 03:58:23PM -0600, Chris Murphy wrote:
>> I don't think this is expected, is it? I can no longer move a subvolume into another subvolume. I can move a subvolume into a directory. This happens with 3.11.3, and 3.12 rc4. I'm not sure yet when the regression first appeared.
>> 
>> Example move subvol to subvol, where home is a subvolume that contains files, and f20inprogress is a newly created (empty) subvolume.
>> 
>> [root@f20s btrfs]# mv home f20inprogress
>> mv: cannot move ‘home’ to ‘f20inprogress/home’: File exists
>> 
> 
> Fixed it with
> 
> [PATCH] Btrfs: use right root when checking for hash collision
> 
> Sorry about that.

This behavior seems to go back quite far. At least 3.9.5 is affected; 3.9 is EOL but does it make sense to fix this for 3.10 and 3.11?


Chris Murphy