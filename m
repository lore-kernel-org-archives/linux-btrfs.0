Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3AXTnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 14:43:43 -0500
Message-ID: <51018EBA.60201@redhat.com>
Date: Thu, 24 Jan 2013 13:42:50 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de> <510175F7.5080806@gmail.com>
In-Reply-To: <510175F7.5080806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
>>> instead of renaming&  keeping the btrfsctl.c copy
>>
>> There is a new momentum to improve the Btrfs-progs quality :)
>>
>> IMO, one step is to get rid of the legacy tools and sources. It wastes
>> time to maintain them and these old tools cause confusion. btrfsctl.c,
>> btrfs-vol.c and btrfs-show.c are not needed anymore. Please correct me
>> if there are plans to use these old tools in future Linux distributions.
>> The "btrfs" tool replaces the legacy "btrfsctl", "btrfs-vol" and
>> "btrfs-show" tools. Below, the usage text of the old tools is quoted.
>> All these tasks are also offered in the "btrfs" tool, and this tool is
>> the newer one.
> 
> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly replaced by by btrfs. Moreover time to time the patches are more complex than the needing because exists these "legacy" programs.
> 
> I checked the debian package, and to me seems that there is no need of {btrfsctl,btrfs-vol,btrfs-show}

Hm, they are shipped in the Fedora package.

For backwards compat, could those be turned into shell scripts which invoke the btrfs tool?

-Eric

> BR
> Goffredo
> 

