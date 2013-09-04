Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40836 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758561Ab3IDOLE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 10:11:04 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Btrfs prog
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAN3gubnrbEWaiJf1VFATgAX+p9btGTDX916BLEmJZG5yt_HA-Q@mail.gmail.com>
Date: Wed, 4 Sep 2013 16:10:49 +0200
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-Id: <A3E04520-431C-4040-A0E8-33752343B110@colorremedies.com>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com> <20130904133207.GC6389@carfax.org.uk> <CAN3gubnrbEWaiJf1VFATgAX+p9btGTDX916BLEmJZG5yt_HA-Q@mail.gmail.com>
To: Giuseppe Fierro <giuseppe@fierro.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 4, 2013, at 3:51 PM, Giuseppe Fierro <giuseppe@fierro.org> wrote:

> Thanks,
> as I can see I misunderstood the meaning of "btrfs filesystem df" I
> was expecting that the 'df' has been to display free space remaining.

Check the archives, this is a long running issue that no one has particularly great answers for because what free space remains depends on future (unknown) usage of the file system. But I still think it's a worse problem to not report anything at all in btrfs fi df, considering the historical point of df is to show space available. And it's also not good that the regular df shows e.g. for raid1, twice the free space as the amount of data that can be saved to the volume.

Chris Murphy