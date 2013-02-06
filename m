Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:46944 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3BFO2F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 09:28:05 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130206142804.GEQA20491.eastrmfepo101.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>; Wed, 6 Feb 2013 09:28:04 -0500
Message-ID: <5112686C.9050300@czarc.net>
Date: Wed, 06 Feb 2013 09:27:56 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Zach Brown <zab@redhat.com>, David Sterba <dsterba@suse.cz>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: btrfs-progs pull request for coverity fixes
References: <20130206004907.GN14246@lenny.home.zabbo.net>
In-Reply-To: <20130206004907.GN14246@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/2013 07:49 PM, Zach Brown wrote:
> Hi gang,
>
> Eric and I went through the warnings that a Coverity scan raised against
> the reasonably recent btrfs-progs that's in Fedora.  We tried to tackle
> the lowest hanging fruit: these are the most obvious and least risky
> fixes.
>
If you ran your tests against the btrfs-progs in Fedora 18 then your 
tests may not have found problems fixed by the "valgrind" patch on F18.  
This patch is not applied to the current David Sterba's integration 
branches.

If you have the time, it might be useful (my opinion) to run your tests 
against Sterba's integration-02130201 branch ... some of the problems 
may be fixed and other not but you also may find some additional 
problems.  IMO, this branch (or something similar) will be the basis for 
a future v0.20 btrfs-progs ... at least that is what I am using/testing 
with.  There are over 80 commits in this branch over what is the baseis 
for the package in Fedora 18.

Gene
