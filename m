Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29257 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759708Ab3JOU6V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 16:58:21 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't mount subvol if default subvol is changed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131015205019.GO5787@twin.jikos.cz>
Date: Tue, 15 Oct 2013 14:58:22 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <64C31F98-8C69-458F-ADCB-14EE19770C1D@colorremedies.com>
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com> <20131015205019.GO5787@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 15, 2013, at 2:50 PM, David Sterba <dsterba@suse.cz> wrote:

> On Tue, Oct 15, 2013 at 01:23:44PM -0600, Chris Murphy wrote:
>> After changing the default subvolume, I can't mount a nested subvolume
>> with a correct relative pathname to the default subvolume; it can only
>> be mounted by absolute path or subvolid.
> 
> The path to subvol= is always taken as absolute, no matter if the path
> starts with / or not.

Looks like this changed with the 3.2 kernel " Subvolumes mountable by full path", I thought that was in addition to relative rather than a total change in behavior. Good to know.

Is the idea that subvolume set-default only affects mount -o defaults behavior and nothing else?


Chris Murphy