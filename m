From: Tomasz Torcz <tomek@crocom.com.pl>
Subject: Re: crc32c implementation on x86 with SSE4.2... CONFIG_BTRFS_HW_SUM
Date: Fri, 17 Oct 2008 08:37:11 +0200
Message-ID: <1224225431.3360.16.camel@s1.crocom.com.pl>
References: <f058a9c30810160640r3a8c8427hc8b35d6881583fb5@mail.gmail.com>
	 <1224164944.6938.61.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224164944.6938.61.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dnia 2008-10-16, czw o godzinie 09:49 -0400, Chris Mason pisze:
> On Thu, 2008-10-16 at 14:40 +0100, Miguel Sousa Filipe wrote:
> > Hi there,
> > 
> > I noticed that btrfs, in the git tree, has its own implementation of
> > crc32c for x86 with SSE4.2 that implement a crc32 instruction.. it
> > appears.
> I don't see intel's patches in mainline yet, but I know there was a
plan
> to get them there.

  It seems to be merged:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8cb51ba8e06570a5fff674b3744d12a1b089f2d0

  Using generic, replaceable by arch version is surely better. This way
you can avoid implementing crc32 for each architecture (like, for
example UltraSPARC T2, which computes crc at healthy 48 GB/s). 

-- 
Tomasz Torcz

