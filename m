From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: A little confused about what remains to make a stable release
Date: Wed, 17 Nov 2010 17:46:30 -0700
Message-ID: <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
References: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
 <20101117225901.GA5367@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101117225901.GA5367@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

 Hello,

>    It's stable *for you* when it functions with the workloads *you*
> expect of it, with a failure rate that is acceptable *to you*.

 I think there's a few ancillary things like a working fsck needed
 before it can even be recommended for widespread use, even to users
 willing to risk any residual bugs. IIRC at this point the utilities
 don't even aspire to provide basic recovery functionality (though
 Chris has posted that fsck is coming).

 Beyond that, the management capabilities at this point don't look
 ready for long term use in a production environment. By this I
 mean adding/removing disks, reshaping arrays, etc. Without that I
 might use BTRFS on top of LVM/RAID just like any other filesystem,
 and there's features I'm looking forward to even if I that's all
 I can do, but without robust management features there's certain
 environments where it just doesn't make sense yet.

 There's one or two other things I'm keeping an eye on. That
 limitation on the number of hardlinks you can have in a directory
 is kinda irksome. Also, dedup needs a way to verify/dedup safely
 before people can start doing stuff like deduping live VM images.

 -Anthony

