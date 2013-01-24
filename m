Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:48801 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3AXVHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 16:07:35 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130124210734.RIPI23841.eastrmfepo103.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 24 Jan 2013 16:07:34 -0500
Message-ID: <5101A295.9090908@czarc.net>
Date: Thu, 24 Jan 2013 16:07:33 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz
Subject: Re: [PATCH 00/13] Btrfs-progs: more patches for integration (integration-20130121)
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <20130121184016.GC7971@twin.jikos.cz> <50FEF32B.6050005@czarc.net> <20130124181308.GT28263@twin.jikos.cz>
In-Reply-To: <20130124181308.GT28263@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/24/2013 01:13 PM, David Sterba wrote:
> On Tue, Jan 22, 2013 at 03:14:35PM -0500, Gene Czarcinski wrote:
>> On 01/21/2013 01:40 PM, David Sterba wrote:
>>> On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
>>>>> I have done some additional scraping of the mailing list to
>>>>> identify some "low hanging fruit" which I consider should
>>>>> be merged into the btrfs-progs repository.
>>> Thanks, I went through them and put together into an integration branch
>>>
>>>    git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121
>> There is a problem with one of the patches:
>>      detect if the disk we are formatting is a ssd
>>
>> The commit comments appear to come from the patch I submitted. However, as I
>> said in the submission, the patch for mkfs.c has to be "refitted" because of
>> a conflict.  The conflict is a result of the patch:
>>      Fix compiler warnings on PPC64
>> which relocated the include "kerncompat.h" to a different line in the mkfs.c
>> file.
> These merge conflicts are inevitable and normal (though sometimes not
> that trivial). My initial aim was to build one linear branch only with
> fixes and git-merge the patches that add features, but this will not be
> easy to merge for much longer, so I'm going to do a linear integration
> branch so others can take them as checkpoint to base the various
> patchsets.
>
Yes, trying to merge branches with lots of changes are effectively 
impossible (impractical?) as far as I am concerned.  Unless it is simple 
I I understand exactly what is happening, I have found it easier/better 
to apply a set of patches one at a time and resolve problems manually.

I just got the subvol show patches applied.  I tried putting it into a 
separate branch and then doing a merge but I could not trust my results 
when I ran mergetool.  And, BTW they subvol show patches to apply with 
not very many problems.  My working branch currently has 44 commits over 
91d9eec and subvol show added another ten.

Gene
