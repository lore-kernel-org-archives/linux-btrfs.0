From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG when removing missing drive (Take 2)
Date: Wed, 20 Oct 2010 21:03:02 -0400
Message-ID: <20101021010302.GW3400@think>
References: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com>
 <AANLkTimu9bpQSPfM1fBsJHnWH-BwysvfKTaN2=d5w2gx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Erik Jensen <eriksjunk@rkjnsn.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimu9bpQSPfM1fBsJHnWH-BwysvfKTaN2=d5w2gx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 20, 2010 at 05:53:34PM -0700, Erik Jensen wrote:
> After some more investigation, I discovered that for some reason btrfs
> is trying to write to the missing drive (devid 5) in the course of
> removing it from the array.  Since this drive is missing, it is
> naturally not writable, leading to the BUG.
> 
> If any other tests would be helpful in tracking down this problem,
> please let me know.

Ok, I'll reproduce this tonight and get a patch out during the day
tomorrow.  Please don't do anything drastic with the drives, we can
definitely pull the data out.

-chris

