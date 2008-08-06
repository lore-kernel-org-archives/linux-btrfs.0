From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Patch - btrfslabel program
Date: Wed, 06 Aug 2008 09:30:38 -0400
Message-ID: <1218029438.15342.60.camel@think.oraclecorp.com>
References: <4898E9DA.9080009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Morey Roof <moreyroof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4898E9DA.9080009@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-05 at 18:01 -0600, Morey Roof wrote:
> I'm new and just getting starting on the source code and figured I
> would start by working on some of the utility programs.  So here is my
> first addition a program called btrfslabel which works pretty much
> just like e2label.  It currently doesn't work on a mounted filesystem
> and I will look at that next.

Neat, thanks.  Could you please move the santiy-checks code into
utils.[ch]?

You'll just need to add an ioctl to change the label on a mounted FS.

-chris


