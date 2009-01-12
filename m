From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Definitive btrfs git tree ?
Date: Mon, 12 Jan 2009 16:28:21 -0500
Message-ID: <1231795701.22806.42.camel@think.oraclecorp.com>
References: <200901130726.08242.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901130726.08242.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-13 at 07:26 +1100, Chris Samuel wrote:
> Hi Chris,
> 
> Now btrfs has made it into the mainline, which git tree is definitive now ?

Only mainline is definitive ;)

We'll have a tree with stable fixes that we want Linus to pull, and
we'll have a development tree with unstable experimental stuff (these
aren't yet named).

For the progs, the btrfs-progs-unstable tree is up to date and safe.
I'll make something with a less scary name later this week, and save the
unstable tree for development.

-chris


