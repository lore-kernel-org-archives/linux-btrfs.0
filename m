Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9042 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbaDNBIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 21:08:48 -0400
Message-ID: <534B355C.2060606@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 09:09:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <20140411091621.GB26503@localhost.localdomain> <20140411173415.GF29256@twin.jikos.cz>
In-Reply-To: <20140411173415.GF29256@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for fixing the problems.

Qu
-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related 
paragraph.
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Date: 2014年04月12日 01:34
> On Fri, Apr 11, 2014 at 05:16:22PM +0800, Liu Bo wrote:
>>> +DEVICE MANAGEMENT
>>> +-----------------
>>> +Btrfs filesystem is capable to manage multiple devices.
>>> +
>>> +Btrfs filesystem use different profiles to manage different RAID level, and
>>> +use balance to rebuild chunks, also devices can be added/removed/replace
>>> +online.
>> s/use/uses/g
>>
>>> +
>>> +Profile::
>>> +Btrfs filesystem use data/metadata profiles to manage allocation/duplication
>>> +mechanism. Profiles like RAID level can be assigned to data and metadata separately.
>> ditto.
> Both fixed at commit time.
>
> Thanks.

