Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:58298 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3AXUwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 15:52:44 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130124205243.QANK23841.eastrmfepo103.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 24 Jan 2013 15:52:43 -0500
Message-ID: <51019F1A.4070408@czarc.net>
Date: Thu, 24 Jan 2013 15:52:42 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/10] add show sub-command for btrfs subvol cli
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/23/2013 03:12 AM, Anand Jain wrote:
> Please accept this patch set which is on top of
>    git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris
>
> to add 'show' sub-command feature for the btrfs subvol cli
> as in an example below..
OK, in spite of saying that these patches did not apply clean, it was 
not terribly difficult to refit what did not apply.  I did this in two 
steps:

1. I created the equivalent of the for-chris branch.  This did not apply 
clean which surprised me.  However, minor things easily handled manually 
in the first patch for utils.c and utils.h plus btrfs-lists.c in a later 
patch.

2. After creating a new set of patches from the above effort, I then 
moved to my working branch with includes all of the patches in the 
integration-20130121 branch [careful, patch 0023 has a conflict in 
mkfs.c] please others.  This time it was a very small problem in 
cmds-qgroup.c.  I am running it now.

Gene
