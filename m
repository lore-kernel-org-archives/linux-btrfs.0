Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3AQLbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 06:31:24 -0500
Date: Thu, 17 Jan 2013 12:31:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1
 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130117113122.GW20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130108164958.GA2044@merlins.org>
 <20130108182541.GE2389@localhost.localdomain>
 <20130108184603.GG2044@merlins.org>
 <20130110162009.GF16943@merlins.org>
 <20130111144952.GA1876@localhost.localdomain>
 <20130113031212.GI4038@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130113031212.GI4038@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 12, 2013 at 07:12:12PM -0800, Marc MERLIN wrote:
> On Fri, Jan 11, 2013 at 09:49:52AM -0500, Josef Bacik wrote:
> > Probably just related to whatever corruption it is you are seeing.
>  
> So I have no corruption afterall, correct?
> 
> That's good news, but then it does mean that unclean sudden shutdowns in the wrong place.
> 
> I still have a truncated fs_image if someone wants it, and with an
> apparently uncorrupted FS, btrfs-image is still dying for me:
> andalfthegreat:~# btrfs-image -c 9 /dev/mapper/cryptroot  /var/tmp/fs_image2
> Check tree block failed, want=4261896192, have=10797364022063960087
> Check tree block failed, want=4261896192, have=10797364022063960087
> Check tree block failed, want=4261896192, have=13996544474027288730
> Check tree block failed, want=4261896192, have=10797364022063960087
> Check tree block failed, want=4261896192, have=10797364022063960087

want= are around 4G, have= numbers are way off, very likely a
corruption. the number does not translate into a meaningful pattern.

david
