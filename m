Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbeDFRF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 13:05:59 -0400
Date: Fri, 6 Apr 2018 19:03:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Ben Parsons <9parsonsb@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Bad magic on superblock on /dev/sda at 65536
Message-ID: <20180406170329.GH8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
> Hi,
> 
> I just had an unexpected restart and now my btrfs pool wont mount.
> The error on mount is:
> 
>     "ERROR: unsupported checksum algorithm 41700"
> 
> and when running
> 
>     btrfs inspect-internal dump-super /dev/sda
>     ERROR: bad magic on superblock on /dev/sda at 65536
> 
> I saw a thread in the mailing list about it:
> https://www.spinics.net/lists/linux-btrfs/msg75326.html
> However I am told on IRC that Qu fixed it using magic.
> 
> Any help would be much appreciated.

In the previous report, there were 2 isolated areas of superblock
damaged. Please post output of

	btrfs inspect dump-super /path

so we can see if it's a similar issue.

In case it is, there's a tool in the btrfs-progs repo that can fix the
individual values.
