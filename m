Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:49798 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 08:41:52 -0400
Message-ID: <5447A5CF.9060405@siedziba.pl>
Date: Wed, 22 Oct 2014 14:40:47 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
In-Reply-To: <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22.10.2014 03:43, Chris Murphy wrote:
> On Oct 21, 2014, at 4:14 PM, Piotr Pawłow<pp@siedziba.pl>  wrote:
>> Looks normal to me. Last time I started a balance after adding 6th device to my FS, it took 4 days to move 25GBs of data.
> It's long term untenable. At some point it must be fixed. It's way, way slower than md raid.
> At a certain point it needs to fallback to block level copying, with a ~ 32KB block. It can't be treating things as if they're 1K files, doing file level copying that takes forever. It's just too risky that another device fails in the meantime.

There's "device replace" for restoring redundancy, which is fast, but 
not implemented yet for RAID5/6.

I think the problem is that balance was originally used for balancing 
data / metadata split - moving stuff out of mostly empty chunks to free 
them and use for something else. It pretty much has to be done on the 
extent level.

Then balance was repurposed for things like converting RAID profiles and 
restoring redundancy and balancing device usage in multi-device 
configurations. It works, but the approach to do it extent by extent is 
slow.

I wonder if we could do some of these operations by just copying whole 
chunks in bulk. Wasn't that the point of introducing logical addresses? 
- to be able to move chunks around quickly without changing anything 
except updating chunk pointers?

BTW: I'd love a simple interface to be able to select a chunk and tell 
it to move somewhere else. I'd like to tell chunks with metadata, or 
with tons of extents: Hey, chunks! Why don't you move to my SSDs? :)
