Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3AYJQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 04:16:31 -0500
Message-ID: <51024F10.5040100@oracle.com>
Date: Fri, 25 Jan 2013 17:23:28 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/10] add show sub-command for btrfs subvol cli
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <51019F1A.4070408@czarc.net>
In-Reply-To: <51019F1A.4070408@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> OK, in spite of saying that these patches did not apply clean, it was
> not terribly difficult to refit what did not apply.  I did this in two
> steps:
>
> 1. I created the equivalent of the for-chris branch.  This did not apply
> clean which surprised me.

  Yes I see it. Not sure where I went wrong, sorry about that,
  now I have sent V2 of this patch set which also includes
  Erics comments.

>  However, minor things easily handled manually
> in the first patch for utils.c and utils.h plus btrfs-lists.c in a later
> patch.
>
> 2. After creating a new set of patches from the above effort, I then
> moved to my working branch with includes all of the patches in the
> integration-20130121 branch [careful, patch 0023 has a conflict in
> mkfs.c] please others.  This time it was a very small problem in
> cmds-qgroup.c.  I am running it now.
>
> Gene
