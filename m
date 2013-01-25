Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:56512 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3AYPtw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:49:52 -0500
Message-ID: <5102A9A7.2000407@giantdisaster.de>
Date: Fri, 25 Jan 2013 16:49:59 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: remove btrfsctl, btrfs-show and btrfs-vol
 from default build
References: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de> <51027339.9030604@czarc.net> <5102A571.8030608@redhat.com>
In-Reply-To: <5102A571.8030608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Jan 2013 09:32:01 -0600, Eric Sandeen wrote:
> On 1/25/13 5:57 AM, Gene Czarcinski wrote:
>> On 06/08/2012 02:00 PM, Stefan Behrens wrote:
>>> Remove btrfsctl, btrfs-show and btrfs-vol from "all" target of Makefile.
> 
> TBH, unless there are objections, I'd rather remove the source files as well.
> 
> Having unbuilt source code lying around is potentially even more confusing.
> 
> I'd at least move it to a deprecated/ subdir or something, but it'll only
> fester and die there as well.  I'd just remove it, if it's time to do so.

Yes, right. Half a year ago, this was a first attempt from me to start a
discussion on this topic. But I agree that the removal of the sources
and the removal in the Makefile should be made in one commit.

Unfortunately Suse is still needing these old files as David wrote.


> Are they fully deprecated?  Is there anything these tools do that btrfs
> does not?

Yes (fully deprecated for 2 years). No (the unified btrfs tool is a full
replacement).

