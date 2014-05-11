Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40486 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751672AbaEKAua convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 20:50:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140511001649.GF27530@merlins.org>
Date: Sat, 10 May 2014 18:50:04 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <A1339B38-993E-48EF-9E36-1E85A6E2F7E4@colorremedies.com>
References: <20140510220710.GA6772@merlins.org> <20140510224249.GA15909@merlins.org> <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com> <20140511001649.GF27530@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 10, 2014, at 6:16 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sat, May 10, 2014 at 06:06:46PM -0600, Chris Murphy wrote:
>> I think the issue might be there are still problems and changing code on the receive side (btrfs-progs). The kernel side code responsible for send is probably working correctly.
> 
> Mmmh, good point, I didn't consider that.
> Do you think I should downgrade btrfs-progs back down from 3.14 to 3.12?

If anything, David's btrfs-integration branch, but I'm not sure what its status is at the moment compared to 3.14.


Chris Murphy