Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:2781 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755359Ab3HZCct convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 22:32:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: uncorrectable errors after btrfs replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3E91F3EB-AE7F-47FE-AAD3-00B08F761911@colorremedies.com>
Date: Sun, 25 Aug 2013 20:32:45 -0600
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <01975867-D9FC-4965-921B-AED6C895EEBA@colorremedies.com>
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com> <434c716a-7687-4738-bb24-f4752ada1e3f@email.android.com> <52138852.3080605@giantdisaster.de> <521A80C5.70208@pook.it> <3E91F3EB-AE7F-47FE-AAD3-00B08F761911@colorremedies.com>
To: Stuart Pook <slp644161@pook.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2013, at 8:07 PM, Chris Murphy <lists@colorremedies.com> wrote:

> ata10.00: failed command: READ FPDMA QUEUED
> 
> Implies it may be an incompatibility between this drive and the controller, possibly disabling NCQ on the drive will fix the problem (set queue depth to 1)

http://serverfault.com/questions/295740/ubuntu-11-04-server-crashing-failed-command-read-fpdma-queued

One found replacing cables solved the problem, another a BIOS update. It could also be port specific.

I'm uncertain if there's enough information to know if the data was written incorrectly, or if it's just reading incorrectly and btrfs is complaining. It might be worth putting the drive on another port with a new cable and seeing if the volume will mount ro and if so if you can access your data.


Chris Murphy