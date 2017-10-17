Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754496AbdJQPyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:54:31 -0400
Date: Tue, 17 Oct 2017 17:52:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: handle unaligned tail of data ranges more
 efficient
Message-ID: <20171017155243.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
 <20171003150604.19596-4-nefelim4ag@gmail.com>
 <20171010163706.GR3521@twin.jikos.cz>
 <CAGqmi76z2nisakzci3W6n=1PLc+8vd+9iKZ3mnhAj64hNVT_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi76z2nisakzci3W6n=1PLc+8vd+9iKZ3mnhAj64hNVT_kQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 01:09:04AM +0300, Timofey Titovets wrote:
> May be then just add a comment at least at one of that functions?
> Like:
> /*
>  * Handle unaligned end, end is inclusive, so always unaligned
>  */

This would be best documented in the data structure definition, so we
don't have to comment each and every test that compares something
against the range.

> Or something like:
> /*
>  * It's obvious, kernel use paging, so range
>  * Almost always have aligned start like 0
>  * and unaligned end like 8192 - 1
>  */
> 
> Or we assume that everybody who look at kernel code, must understood
> that basic things?

Some level of understanding is required of course, but it's different
for everybody. If the semantics or constraints of code/structures are not
discoverable, then it should be documented.  Adding comment-only patches
is ok, but adding trivial or commenting on the obvious is pointless. IME
the sense of what is/not trivial comes after reading a lot of code.
