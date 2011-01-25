From: Chris Samuel <chris@csamuel.org>
Subject: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re: Bug
 in mkfs.btrfs?!)
Date: Tue, 25 Jan 2011 11:15:11 +1100
Message-ID: <4D3E160F.4050006@csamuel.org>
References: <20110122144513.GA2539@scooter> <20110122145222.GB2539@scooter> <20110122151124.GC29985@carfax.org.uk> <20110122155612.GA3664@scooter> <20110123181827.GF29985@carfax.org.uk> <4D3CA568.7050506@libero.it> <20110124130104.GA7354@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kreijack@inwind.it, Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124130104.GA7354@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

/*
 * CC'd to linux-kernel in case they have any feedback on this.
 *
 * Long thread, trying to work out why mkfs.btrfs failed to
 * make a filesystem on an encrypted loopback mount called
 * /dev/loop2. Cause turned out to be mkfs.btrfs calling
 * LOOP_GET_STATUS to find out if the block device was mounted
 * and getting a truncated device name back and so it later
 * fails when lstat() is called on the truncated device path.
 *
 * The long device name for the encrypted loopback mount was
 * because /dev/disk/by-id/$ID was used when Felix created it
 * to cope with devices moving around.
 */

On 25/01/11 00:01, Felix Blanke wrote:

> you were talking about the LOOP_GET_STATUS function. I'm not
> quite sure where does it came from. Is it part of the kernel?
> Or does it come from the util-linux package?

It's in the kernel, and there is both LOOP_GET_STATUS (old
implementation) and LOOP_GET_STATUS64 (new implementation).

They return structures called loop_info and loop_info64
respectively and both are defined in include/linux/loop.h .

Sadly in both cases the lengths of paths are defined to be
LO_NAME_SIZE which is currently 64 and hence either
implementation will cause the problematic:

lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par",
0x7fffa30b3cf0) = -1 ENOENT (No such file or directory)

I've CC'd this to the LKML in case they have any feedback on
this apparent problem with the API.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
