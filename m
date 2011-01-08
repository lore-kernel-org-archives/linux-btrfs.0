From: Peter A <loony@loonybin.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Fri, 7 Jan 2011 19:27:37 -0500
Message-ID: <201101071927.38249.loony@loonybin.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <201101052258.36457.loony@loonybin.org> <1294338857-sup-1440@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294338857-sup-1440@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 06, 2011 01:35:15 pm Chris Mason wrote:
> What is the smallest granularity that the datadomain searches for in
> terms of dedup?
> 
> Josef's current setup isn't restricted to a specific block size, but
> there is a min match of 4k.
I talked to a few people I know and didn't get a clear answer either... 
However, 512 bytes came up more than once. 

I'm not really worried about the size of region to be used, but about 
offsetting it... its so easy to create large tars, ... where the content is 
offset by a few bytes, mutliples of 512 and such.

Peter.

-- 
Censorship: noun, circa 1591. a: Relief of the burden of independent thinking.
