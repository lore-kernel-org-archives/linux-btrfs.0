Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3JaW3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 18:29:38 -0400
Date: Thu, 31 Oct 2013 23:29:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance empty filesystem loses raid profile for data
Message-ID: <20131031222936.GN8516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAC4gV=4Y-Yn4Wc=VSXTONPaaxA1t_GSN6JR2ZPzh59mOWNPy4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC4gV=4Y-Yn4Wc=VSXTONPaaxA1t_GSN6JR2ZPzh59mOWNPy4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 10:51:28AM -0400, Frank Holton wrote:
> So I just noticed this while running some tests and am not sure if
> this is the expected behavior but it doesn't seem right to me.
> 
> If you run a balance on an empty filesystem, it removes all of the
> data chunks. Writing files to the fs results in a new data chunk being
> allocated of type single completely ignoring what the filesystem was
> created with.

It's not entirely right, yes. There is currently no notion of default
profile to create (eg. the one that was given at mkfs time). Single is
the first in the list. I hope we'll be able to solve that with the
persistent object properties.

david
