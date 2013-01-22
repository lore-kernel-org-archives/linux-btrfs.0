Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:44238 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3AVUOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 15:14:36 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122201436.ILAN6475.eastrmfepo202.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 15:14:36 -0500
Message-ID: <50FEF32B.6050005@czarc.net>
Date: Tue, 22 Jan 2013 15:14:35 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/13] Btrfs-progs: more patches for integration (integration-20130121)
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <20130121184016.GC7971@twin.jikos.cz>
In-Reply-To: <20130121184016.GC7971@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2013 01:40 PM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
>> >I have done some additional scraping of the mailing list to
>> >identify some "low hanging fruit" which I consider should
>> >be merged into the btrfs-progs repository.
> Thanks, I went through them and put together into an integration branch
>
>    git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121
There is a problem with one of the patches:
     detect if the disk we are formatting is a ssd

The commit comments appear to come from the patch I submitted. However, 
as I said in the submission, the patch for mkfs.c has to be "refitted" 
because of a conflict.  The conflict is a result of the patch:
     Fix compiler warnings on PPC64
which relocated the include "kerncompat.h" to a different line in the 
mkfs.c file.

It appears that you used the original patch.  I noticed that you merged 
from a different branch and I suspect that that branch did not have the 
"Fix compiler warnings" patch applied first.

I suggest you use the patch I submitted.

Gene
