Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:39130 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3AYSre (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 13:47:34 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130125184733.MRWX23841.eastrmfepo103.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 25 Jan 2013 13:47:33 -0500
Message-ID: <5102D344.6040807@czarc.net>
Date: Fri, 25 Jan 2013 13:47:32 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Eric Sandeen <sandeen@redhat.com>,
        kreijack@inwind.it, Goffredo Baroncelli <kreijack@tiscalinet.it>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de> <510175F7.5080806@gmail.com> <51018EBA.60201@redhat.com> <5101B131.6010804@tiscalinet.it> <5102AF4E.2000300@redhat.com> <20130125164829.GC1371@carfax.org.uk>
In-Reply-To: <20130125164829.GC1371@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/25/2013 11:48 AM, Hugo Mills wrote:
> On Fri, Jan 25, 2013 at 10:14:06AM -0600, Eric Sandeen wrote:
>> On 1/24/13 4:09 PM, Goffredo Baroncelli wrote:
>>> On 01/24/2013 08:42 PM, Eric Sandeen wrote:
>>>> On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
>>>>> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
>>>>>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
>>>>>>> instead of renaming&   keeping the btrfsctl.c copy
>>>>>> There is a new momentum to improve the Btrfs-progs quality :)
>>>>>>
>>>>>> IMO, one step is to get rid of the legacy tools and sources. It
>>>>>> wastes time to maintain them and these old tools cause confusion.
>>>>>> btrfsctl.c, btrfs-vol.c and btrfs-show.c are not needed anymore.
>>>>>> Please correct me if there are plans to use these old tools in
>>>>>> future Linux distributions. The "btrfs" tool replaces the legacy
>>>>>> "btrfsctl", "btrfs-vol" and "btrfs-show" tools. Below, the usage
>>>>>> text of the old tools is quoted. All these tasks are also offered
>>>>>> in the "btrfs" tool, and this tool is the newer one.
>>>>> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly
>>>>> replaced by by btrfs. Moreover time to time the patches are more
>>>>> complex than the needing because exists these "legacy" programs.
>>>>>
>>>>> I checked the debian package, and to me seems that there is no need
>>>>> of {btrfsctl,btrfs-vol,btrfs-show}
>>>> Hm, they are shipped in the Fedora package.
>>> The same is true for the debian package, but are these used in Fedora ?
>>>
>>>> For backwards compat, could those be turned into shell scripts which
>>>> invoke the btrfs tool?
>>> I don't see any gain to maintains a script bash (which has to be
>>> written from scratch) instead of maintains the current C code.
>> It should be a trivial bash script to convert the calls, and it should
>> require very little maintenance.  Much less than the hundreds of lines
>> of duplicated C code, I think.
>>
>> If nobody needs them, though, no reason for even a bash script.
>>
>> David, Suse may be using them now, but probably can adapt?
>> Anaconda said it could drop the use of btrfsctl.  :)
>     I've just asked someone I know at Canonical, and he says there's no
> use of these tools in the Ubuntu installer. (Disclaimer: it's not
> entirely his area, and there's probably other places to look, like
> udev rules, but on a cursory glance, it should be OK).
>
>     I've also checked with the Debian installer people, and they're not
> using the deprecated tools either. Further, these searches:
>
> http://codesearch.debian.net/search?q=btrfs-show
> http://codesearch.debian.net/search?q=btrfs-vol
> http://codesearch.debian.net/search?q=btrfsctl
>
> suggest that there's very little impact over the rest of the system as
> well.
>
>     Hugo.
>
I took a look at Stefan's patch to Makefile and only the building and 
installation of the legacy apps has been eliminated.

This is a good first step so that if someone does need one of these 
apps, they can still be made.  Then, at some later time, remove the 
targets in Makefile and delete the source files.

Or, do it all now? [my preference]

Comments?

Gene
