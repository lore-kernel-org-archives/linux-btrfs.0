Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3BFPFl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Feb 2013 10:05:41 -0500
Message-ID: <51127117.4050409@redhat.com>
Date: Wed, 06 Feb 2013 09:04:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org, Zach Brown <zab@redhat.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: btrfs-progs pull request for coverity fixes
References: <20130206004907.GN14246@lenny.home.zabbo.net> <5112686C.9050300@czarc.net>
In-Reply-To: <5112686C.9050300@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/6/13 8:27 AM, Gene Czarcinski wrote:
> On 02/05/2013 07:49 PM, Zach Brown wrote:
>> Hi gang,
>> 
>> Eric and I went through the warnings that a Coverity scan raised
>> against the reasonably recent btrfs-progs that's in Fedora.  We
>> tried to tackle the lowest hanging fruit: these are the most
>> obvious and least risky fixes.
>> 
> If you ran your tests against the btrfs-progs in Fedora 18 then your
> tests may not have found problems fixed by the "valgrind" patch on
> F18.  This patch is not applied to the current David Sterba's
> integration branches.

The original one was done against F18 with the valgrind patch
in place, yes.  So it may have missed several things.  I can easily
do the same analysis against any codebase if/when it's appropriate.

> If you have the time, it might be useful (my opinion) to run your
> tests against Sterba's integration-02130201 branch ... some of the
> problems may be fixed and other not but you also may find some
> additional problems.  IMO, this branch (or something similar) will be
> the basis for a future v0.20 btrfs-progs ... at least that is what I
> am using/testing with.  There are over 80 commits in this branch over
> what is the baseis for the package in Fedora 18.

I agree that we need to re-run against all those patches, but I think
I will wait until they make it all the way upstream.

Until it gets to the point where development and patch
integration happens upstream (or at least in an orderly, predictable
manner), and we have timely releases of userspace for distro consumption,
it's going to be a little hit and miss with tools like this, since
there are so many different codebases out there right now, with distros
all maintaining their own large patchsets.

There are certainly more static analysis issues to fix, but Zach
and I thought we'd just see if this group of patches managed to
make it upstream before we went a lot further with it.

Thanks,
-Eric

> Gene

