From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 11:13:32 -0500
Message-ID: <20100226161332.GA12841@think>
References: <20100225004004.GK25641@think>
 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
 <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gustavo Alves <gjalves@gjalves.com.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 03:28:19PM -0300, Gustavo Alves wrote:
> I've got the same error before in a similar situation (24 partitions,
> only two with problems). Unfortunally I erased all data after this
> error. Strange that all I've done was shutdown and poweron the
> machine.

Basically it looks like the tree of data checksums isn't right.  Which
kernels were you running when you had these problems?

-chris
