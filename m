From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Mon, 16 Jan 2012 08:54:42 -0500
Message-ID: <20120116135442.GA28487@shiny>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2012 at 04:28:47PM -0800, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

Thanks Andi, I've queued this up to a btrfs snappy branch.  I put the
commits against 3.2 instead of 3.3 though so people could try it out.

The only problem I've hit is that snappy is failing xfstests number 135.
It's reproducible on an empty FS.  Could you please take a look?

-chris
