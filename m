From: Peter A <loony@loonybin.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 11:11:35 -0500
Message-ID: <201101061111.35134.loony@loonybin.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <201101060952.50500.loony@loonybin.org> <4D25DA97.9010705@bobich.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D25DA97.9010705@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 06, 2011 10:07:03 am you wrote:
> I'd be interested to see the evidence of the "variable length" argument.
> I have a sneaky suspicion that it actually falls back to 512 byte
> blocks, which are much more likely to align, when more sensibly sized
> blocks fail. The downside is that you don't really want to store a 32
> byte hash key with every 512 bytes of data, so you could peel off 512
> byte blocks off the front in a hope that a bigger block that follows
> will match.
> 
> Thinking about it, this might actually not be too expensive to do. If
> the 4KB block doesn't match, check 512 byte sub-blocks, and try peeling
> them, to make the next one line up. If it doesn't, store the mismatch as
> a full 4KB block and resume. If you do find a match, save the peeled 512
> byte blocks separately and dedupe the 4KB block.
> 
> In fact, it's rather like the loop peeling optimization on a compiler,
> that allows you to align the data to the boundary suitable for vectorizing.
I'm not sure about this but to be honest I can not see any other way. 
Otherwise, how would you ever find a match? You can not store checksums of 
random sub-sections hoping that eventually stuff will match up... 512 byte is 
probably the best choice as its been a "known block size" since the dawn of 
unix.


> Actually, see above - I believe I was wrong about how expensive
> "variable length" block size is likely to be. It's more expensive, sure,
> but not orders of magnitude more expensive, and as discussed earlier,
> given the CPU isn't really the key bottleneck here, I think it'd be
> quite workable.
Hmm - from my work with DD systems, it seems to be the CPU that ends up being 
the limiting factor on dedupe performance... But again, it seems that you have 
much deeper insight into this topic and have already drawn up an algorithm in 
your mind :)

Peter.

-- 
Censorship: noun, circa 1591. a: Relief of the burden of independent thinking.
