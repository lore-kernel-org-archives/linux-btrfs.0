From: Chris Mason <chris.mason@oracle.com>
Subject: Re: AGs in btrfs
Date: Mon, 04 Aug 2008 08:45:36 -0400
Message-ID: <1217853936.29139.39.camel@think.oraclecorp.com>
References: <alpine.LNX.1.10.0808022018190.21001@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0808022018190.21001@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-08-02 at 20:20 -0400, Jan Engelhardt wrote:
> Hi,
> 
> 
> I was wondering whether btrfs has a concept similar to xfs's "allocation 
> groups", which, as far as I understand, means that the filesystem has 
> multiple B-tree roots to allow for more finegrained locking and desaster 
> containment (losing only 1/16th of the fs in a medium-worst case).

Yes and no, we'll eventually have multiple extent allocation trees that
provide some of what the AGs do.  Pulling out hte btree roots for more
fault tolerance is something we need to study.

-chris


