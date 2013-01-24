Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:52220 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3AXWJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 17:09:30 -0500
Message-ID: <5101B131.6010804@tiscalinet.it>
Date: Thu, 24 Jan 2013 23:09:53 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de> <510175F7.5080806@gmail.com> <51018EBA.60201@redhat.com>
In-Reply-To: <51018EBA.60201@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/24/2013 08:42 PM, Eric Sandeen wrote:
> On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
>> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
>>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
>>>> instead of renaming&   keeping the btrfsctl.c copy
>>>
>>> There is a new momentum to improve the Btrfs-progs quality :)
>>>
>>> IMO, one step is to get rid of the legacy tools and sources. It
>>> wastes time to maintain them and these old tools cause confusion.
>>> btrfsctl.c, btrfs-vol.c and btrfs-show.c are not needed anymore.
>>> Please correct me if there are plans to use these old tools in
>>> future Linux distributions. The "btrfs" tool replaces the legacy
>>> "btrfsctl", "btrfs-vol" and "btrfs-show" tools. Below, the usage
>>> text of the old tools is quoted. All these tasks are also offered
>>> in the "btrfs" tool, and this tool is the newer one.
>>
>> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly
>> replaced by by btrfs. Moreover time to time the patches are more
>> complex than the needing because exists these "legacy" programs.
>>
>> I checked the debian package, and to me seems that there is no need
>> of {btrfsctl,btrfs-vol,btrfs-show}
>
> Hm, they are shipped in the Fedora package.

The same is true for the debian package, but are these used in Fedora ?

>
> For backwards compat, could those be turned into shell scripts which
> invoke the btrfs tool?

I don't see any gain to maintains a script bash (which has to be written 
from scratch) instead of maintains the current C code.

These programs were deprecated two years ago [1]. If some distribution 
need them, could maintain them as separate patch. But I think that the 
mainstream should remove.



>
> -Eric
>
>> BR Goffredo
>>
>
>


[1] $ git log 002d021c^..002d021c
commit 002d021c5f2d838394e850e304546ffad283518a
Author: Goffredo Baroncelli <kreijack@libero.it>
Date:   Sun Dec 5 17:47:36 2010 +0000

     Deprecate btrfsctl, btrfs-show, btrfs-vol

     Hi all,

     the patch below deprecates the following programs

     * btrfsctl
     * btrfs-vol
     * btrfs-show

     the reason is simple, these programs are superseded by the btrfs 
utility,
     both in terms of documentation, usability and bug. The goal is to avoid
     to duplicate codes and avoid update two programs.

     The patch adds a warning in the man pages, in the INSTALL file and 
in the
     programs.
[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
