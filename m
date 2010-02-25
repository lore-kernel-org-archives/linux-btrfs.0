From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 15:23:58 -0500
Message-ID: <20100225202358.GC10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
> Mounting btrfs corrupts memory and causes nasty crashes within a few
> seconds.  This seems to happen even if the mount fails (note the
> unrecognized mount option).  This is a regression from 2.6.32, and
> I've attached an example.
> 

And it only happens when you mount a btrfs fs?  Can you show me a trace of when
you mount a btrfs fs with valid mount options?  I'd like to see if we're not
cleaning up something properly or what.  Thanks,

Josef
