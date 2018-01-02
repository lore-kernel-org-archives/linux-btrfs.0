Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751228AbeABR5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 12:57:12 -0500
Date: Tue, 2 Jan 2018 18:55:04 +0100
From: David Sterba <dsterba@suse.cz>
To: David Disseldorp <ddiss@suse.de>
Cc: Ceriel Jacobs <linux-ide@crashplan.pro>, linux-btrfs@vger.kernel.org
Subject: Re: Project idea: reduce boot time/RAM usage: option to
 disable/delay raid6_pq and xor kmod
Message-ID: <20180102175504.GY3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <6f082a1d-ed15-2583-fabf-9aa7c80baef0@crashplan.pro>
 <20171228211807.60f115f4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20171228211807.60f115f4@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 28, 2017 at 09:18:07PM +0100, David Disseldorp wrote:
> On Sun, 24 Dec 2017 13:31:40 +0100, Ceriel Jacobs wrote:
> 
> > Saving:
> > 1. ± 0.4 seconds of boot time (10% of boot until root)
> > 2. ± 150k of RAM
> > 3. ± 75k of disk space
> 
> Thanks for bringing this up - I'm also particularly frustrated by the
> boot delay caused by the raid6 algorithm benchmark (1).
> 
> > New kernel command-line parameters?
> > a.) disable, like:
> >      - btrfs=noraid6_pq
> >      - btrfs=noraid (=no xor at all)
> > b.) delay raid6_pq and xor module loading, for cases where root mount 
> > doesn't need raid6_pq and/or xor.
> 
> c) It might not help with (2) or (3), but I'd be happy with an option to
> preselect the raid6 algorithm, so that the benchmark didn't run on each
> boot.

The preselection looks like the least intrusive option.

Another other option is loading the modules on demand (either explicitly
eg.  inside the first mount or implicitly on the first use of the loaded
module), which might be tricky.

The crc32c functions are loaded through the crypto API, and not as a
direct module, but still initialized in the btfs module initialization
itself.
