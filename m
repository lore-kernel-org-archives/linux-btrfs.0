Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:47347 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3ARVCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 16:02:11 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130118210210.MPSS23841.eastrmfepo103.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 18 Jan 2013 16:02:10 -0500
Message-ID: <50F9B851.1020908@czarc.net>
Date: Fri, 18 Jan 2013 16:02:09 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        josef@toxicpanda.com
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20130118172226.GC19967@twin.jikos.cz>

On 01/18/2013 12:22 PM, David Sterba wrote:
> On Fri, Jan 18, 2013 at 10:33:18AM -0500, Gene Czarcinski wrote:
>> I would like to recommend some additional patches for inclusion since they
>> are currently part of the Fedora 18 btrfs-tools package.
> Thanks. For now I'd like to gather all the small bugfixes and updates
> that are likely not to create any significant conflicts with whatever
> Chris has in his tree and skip new features, UI changes or non-obvious
> fixes.
>
>> Josef Bacik:  detect if the disk we are formatting is a ssd V2
>> http://article.gmane.org/gmane.comp.file-systems.btrfs/18749
> This is IMO a safe feature, the comments were addressed in the final
> patch so we can try to push it.
>
>> This one may be a little more of a problem since the suggested man update is
>> missing and there is a second part for the kernel (status unknown).
>> Josef Bacik:  add btrfs device ready command
>> http://article.gmane.org/gmane.comp.file-systems.btrfs/18129
>> Since Fedora uses a "stock" a kernel as possible, I suspect the
>> corresponding patch is applied.
> The kernel part of 'device ready' was merged to 3.6.
>
>> There are two or three other patches that appear to make sense but I have no
>> idea if they have been submitted.
> Please send them to the list.
>
Josef Bacik <josef@toxicpanda.com> is the current Fedora maintainer as 
indicated in bugzilla.
<mailto:josef@toxicpanda.com>
Currently in Fedora 18, btrfs-progs is the "v0.20-rc1 with git commit id 
<mailto:josef@toxicpanda.com>91d9eec" plus a total of seven patches.  
Two of those patches from the list which I have already indicated.  The 
rest of those patches have been around for a while (at least since mid 
2011) and I cannot find any doc.

While I could send them in (and will if needed), I feel a little uneasy 
since Josef is responsible in Fedora.  While this may be a different 
individual since the email address is different, I suspect this Josef is 
the same Josef who wrote the other two patches and he may be able to 
speak to them better.

I have been scraping mailing list for all of the btrfs-progs patches and 
plan to gradually test them.  Since it appears you will be doing 
something similar, if you want to point me to some for testing, I will 
give it a shot with some virtual and some real-iron testing.  And 
sometimes it is also a matter of the time needed to refit/rebase patches.

Gene
