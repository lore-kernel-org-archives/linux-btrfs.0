From: Daniel Farina <drfarina@acm.org>
Subject: Re: A little confused about what remains to make a stable release
Date: Wed, 17 Nov 2010 22:24:36 -0800
Message-ID: <AANLkTi=rx4Z3Ka7NEw3=Yd+pk1sjaBZnLwkPOxr9xRbz@mail.gmail.com>
References: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
 <20101117225901.GA5367@vlad.carfax.org.uk> <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 4:46 PM, Anthony Roberts
<btrfs-devel@arbitraryconstant.com> wrote:
> I think there's a few ancillary things like a working fsck needed
> before it can even be recommended for widespread use, even to users
> willing to risk any residual bugs. IIRC at this point the utilities
> don't even aspire to provide basic recovery functionality (though
> Chris has posted that fsck is coming).

Yes, I think this is a rather big one, and one of the more directly
addressed issues given the documentation at hand. I'm glad it looks
like it is getting attention.

> Beyond that, the management capabilities at this point don't look
> ready for long term use in a production environment. By this I
> mean adding/removing disks, reshaping arrays, etc. Without that I
> might use BTRFS on top of LVM/RAID just like any other filesystem,
> and there's features I'm looking forward to even if I that's all
> I can do, but without robust management features there's certain
> environments where it just doesn't make sense yet.

I'd really like to see btrfs become able to simplify my life by
removing LVM and/or RAID from the equation, that would be a very
compelling reason to use it for me. Is there a place with a little
more detail on what's missing to complete the storage-pool
functionality?

> There's one or two other things I'm keeping an eye on. That
> limitation on the number of hardlinks you can have in a directory
> is kinda irksome.

I've heard this may require a format change, which if correct could be
the cause of some reticence to use btrfs for very large file systems.

> Also, dedup needs a way to verify/dedup safely
> before people can start doing stuff like deduping live VM images.

Hmm. Is that going to require a format change? Somehow it seems less likely...

Cheers.

--
fdr
