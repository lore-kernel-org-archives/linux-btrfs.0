Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759032Ab3BNVU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 16:20:59 -0500
Message-ID: <511D5539.1010708@redhat.com>
Date: Thu, 14 Feb 2013 15:20:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <20130214202324.GD3919@shiny.masoncoding.com>
In-Reply-To: <20130214202324.GD3919@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/14/13 2:23 PM, Chris Mason wrote:
> On Thu, Feb 14, 2013 at 11:30:03AM -0700, Eric Sandeen wrote:
>> The core of this is shamelessly stolen from xfsprogs.
>>
>> Use blkid to detect an existing filesystem or partition
>> table on any of the target devices.  If something is found,
>> require the '-f' option to overwrite it, hopefully avoiding
>> disaster due to mistyped devicenames, etc.
> 
> So, this has always been the one thing I didn't want to steal from XFS.
> I don't have a good reason though, and it seems like it is time to bring
> this in.

If you really don't want to, I'm not wedded to it.  It just came up on the 
other thread, and it's easy enough to throw it out there for discussion.

I don't like a million "are you really sure?!"'s from tools, but now 
and then it's nice to have a little barrier to screwup.

So, do as you like with it, I won't be offended if you don't want it.

> Just to get back at you though, I'll turn on an incandescent light bulb
> every time I have to use -f.

NOOOO that seals the deal.  I retract the patch.   ;)

-Eric

> -chris
> 

