Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3B0Wt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 17:49:28 -0500
Message-ID: <512E8D44.1050001@redhat.com>
Date: Wed, 27 Feb 2013 14:48:36 -0800
From: Andy Grover <agrover@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>, penn43@gmx.com,
        linux-btrfs@vger.kernel.org
Subject: Re: Writing a wtapper for BTRFS
References: <512E01BD.2040302@gmx.com> <20130227130846.GM14283@carfax.org.uk> <20130227151957.GG27541@twin.jikos.cz> <20130227213421.GO1658@lenny.home.zabbo.net>
In-Reply-To: <20130227213421.GO1658@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2013 01:34 PM, Zach Brown wrote:
> On Wed, Feb 27, 2013 at 04:19:57PM +0100, David Sterba wrote:
>> On Wed, Feb 27, 2013 at 01:08:46PM +0000, Hugo Mills wrote:
>>>     You may want to look at the btrfs-progs libify patches (posted to
>>> this list in the last couple of months), which try to pull out the
>>> more useful bits of btrfs-progs as a userspace C API.
>>
>> FYI, libify patch will be in the next integration branch.
>>
>>>     You may also want to look at the bits I implemented in python[2]
>>> for a subset of the btrfs ioctls and data structures in btrfs-gui.
>>>
>>>     Other than that, it's down to the data structures documentation on
>>> the wiki[1], and reading through ioctl.h.
>>
>> bedup https://github.com/g2p/bedup does python binding, in a different
>> way than btrfs-gui.
>
> Andy also mentioned being interested in language bindings of a libified
> btrfs-progs, cc:ing.

Yeah. Python/otherlang wrappers around a btrfs-progs C api seem 
preferable to each binding calling ioctls themselves, no? I think every 
common language is going to eventually want a btrfs lib.

-- Andy

