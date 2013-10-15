Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:16141 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759560Ab3JOVwz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 17:52:55 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: regression, can't mount subvol if default subvol is changed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131015214849.GP5787@twin.jikos.cz>
Date: Tue, 15 Oct 2013 15:52:55 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <31AE2480-274F-4726-9E29-33495E02DD81@colorremedies.com>
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com> <20131015205019.GO5787@twin.jikos.cz> <64C31F98-8C69-458F-ADCB-14EE19770C1D@colorremedies.com> <20131015214849.GP5787@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 15, 2013, at 3:48 PM, David Sterba <dsterba@suse.cz> wrote:

> On Tue, Oct 15, 2013 at 02:58:22PM -0600, Chris Murphy wrote:
>> Looks like this changed with the 3.2 kernel " Subvolumes mountable by
>> full path", I thought that was in addition to relative rather than a
>> total change in behavior. Good to know.
> 
> Yes, the pre-3.2 behaviour was limited to subvolumes in the toplevel
> subvolume, nested subvols were mountable via subvolrootid, but that was
> only a clumsy temporary workaround.
> 
>> Is the idea that subvolume set-default only affects mount -o defaults
>> behavior and nothing else?
> 
> Yes.

Great, thanks for the clarification.

Chris Murphy
