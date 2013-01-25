Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3AYQPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 11:15:21 -0500
Message-ID: <5102AF4E.2000300@redhat.com>
Date: Fri, 25 Jan 2013 10:14:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@tiscalinet.it>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de> <510175F7.5080806@gmail.com> <51018EBA.60201@redhat.com> <5101B131.6010804@tiscalinet.it>
In-Reply-To: <5101B131.6010804@tiscalinet.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/24/13 4:09 PM, Goffredo Baroncelli wrote:
> On 01/24/2013 08:42 PM, Eric Sandeen wrote:
>> On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
>>> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
>>>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
>>>>> instead of renaming&   keeping the btrfsctl.c copy
>>>>
>>>> There is a new momentum to improve the Btrfs-progs quality :)
>>>>
>>>> IMO, one step is to get rid of the legacy tools and sources. It
>>>> wastes time to maintain them and these old tools cause confusion.
>>>> btrfsctl.c, btrfs-vol.c and btrfs-show.c are not needed anymore.
>>>> Please correct me if there are plans to use these old tools in
>>>> future Linux distributions. The "btrfs" tool replaces the legacy
>>>> "btrfsctl", "btrfs-vol" and "btrfs-show" tools. Below, the usage
>>>> text of the old tools is quoted. All these tasks are also offered
>>>> in the "btrfs" tool, and this tool is the newer one.
>>>
>>> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly
>>> replaced by by btrfs. Moreover time to time the patches are more
>>> complex than the needing because exists these "legacy" programs.
>>>
>>> I checked the debian package, and to me seems that there is no need
>>> of {btrfsctl,btrfs-vol,btrfs-show}
>>
>> Hm, they are shipped in the Fedora package.
> 
> The same is true for the debian package, but are these used in Fedora ?
> 
>>
>> For backwards compat, could those be turned into shell scripts which
>> invoke the btrfs tool?
> 
> I don't see any gain to maintains a script bash (which has to be
> written from scratch) instead of maintains the current C code.

It should be a trivial bash script to convert the calls, and it should
require very little maintenance.  Much less than the hundreds of lines
of duplicated C code, I think.

If nobody needs them, though, no reason for even a bash script.

David, Suse may be using them now, but probably can adapt?
Anaconda said it could drop the use of btrfsctl.  :)

-Eric


