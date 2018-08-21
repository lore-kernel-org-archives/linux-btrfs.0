Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727608AbeHUTei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 15:34:38 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180821151126.GE24025@twin.jikos.cz>
References: <20180821151126.GE24025@twin.jikos.cz> <20180821142000.GC24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk> <476.1534859190@warthog.procyon.org.uk> <4150.1534862046@warthog.procyon.org.uk>
To: dsterba@suse.cz
Cc: dhowells@redhat.com, clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: Do btrfs compression option changes need to be atomic?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Aug 2018 17:13:51 +0100
Message-ID: <14514.1534868031@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> wrote:

> The ordering of the bits set/cleared can prevent unwanted combinations,
> like: when the COMPRESS bit is set, there's no NODATACOW anymore:
> 
> - clear NODATACOW
> - set compress_type
> - set COMPRESS
> 
> I haven't checked with the sources if this is so.

The current code doesn't use memory barriers or atomic ops, so you must assume
that those memory operations can be reordered/merged by the compiler or the
cpu.

> So the changes would be possible in one atomic (bitwise) call? Instead
> of:
> 
>   clear_bit(opts, NODATACOW)
>   set_bit(opts, COMPRESS)
> 
> do:
> 
>   set_bits_with_mask(opts, COMPRESS, BTRFS_DATA__STORAGE_OPT)

After the mount API changes, the value for the variable will be composed in a
separate context and then applied with a single assignment after printing any
messages about changes in active options.

> Side note: up to now we're all used to the NO* naming and semantics of
> the feature bits, so it might take some time to do the mental switch.

Yeah - I've actually switched them all to positive naming in what I have so
far as it simplifies the code and makes it easier to think about (for me at
least).

David
