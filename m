Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38718 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbbEEVSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 17:18:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpkEO-0001ad-MI
	for linux-btrfs@vger.kernel.org; Tue, 05 May 2015 23:18:20 +0200
Received: from host-78-149-209-236.as13285.net ([78.149.209.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 23:18:20 +0200
Received: from samtygier by host-78-149-209-236.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 23:18:20 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: Re: [PATCH] btrfs-progs: check metadata redundancy
Date: Tue, 05 May 2015 22:18:07 +0100
Message-ID: <mibc2f$a9$1@ger.gmane.org>
References: <mi2sgj$urs$1@ger.gmane.org> <20150505145432.GG5099@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <20150505145432.GG5099@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/15 15:54, David Sterba wrote:
> On Sat, May 02, 2015 at 05:03:31PM +0100, sam tygier wrote:
>> Currently BTRFS allows you to make bad choices of data and
>> metadata levels. For example -d raid1 -m raid0 means you can
>> only use half your total disk space, but will loose everything
>> if 1 disk fails. This patch prevents you creating the situation
>> another will be need to prevent rebalancing in to it.
>>
>> When making a filesystem check that metadata mode is at least
>> as redundant as the data mode. For example don't allow:
>> 	-d raid1 -m raid0
> 
> This is enforcing some policty that makes sense for some usecases, but I
> think that the tool should be flexible enough to create any kind of raid
> profiles. It's up to the user. I'm willing to add a warning that the
> profiles seem fishy, but failing mkfs without any way to override that
> is IMHO not a good thing.

There already seems to be policy in test_num_disk_vs_raid() disallowing
DUP for multiple devices. Is there really a useful case better protected
data than metadata?

In btrfs_balance() fs/btrfs/volumes.c, operations that reduce integrity
require a 'force' option. Would that be a good way of handling
questionable data/metadata combinations? If so should it overload the
existing for option, or additional one, e.g. --force-raid-level?

Otherwise I could redo it as just a warning.

If wrote a similar check for rebalancing is there a way to share the
group_profile_max_safe_loss() function between the kernel and btrfs-progs?

Thanks,
Sam

