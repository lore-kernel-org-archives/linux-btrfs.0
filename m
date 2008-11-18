From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New disk format pushed out to btrfs-unstable
Date: Tue, 18 Nov 2008 16:53:03 -0500
Message-ID: <1227045183.4763.1.camel@think.oraclecorp.com>
References: <1227029266.787.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227029266.787.13.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-11-18 at 12:27 -0500, Chris Mason wrote:
> Hello everyone,
> 
> The btrfs unstable git trees now have a new disk format.  The changes
> include:

Just a quick warning since I have to run out the door, this current code
doesn't work for a root device because the mount -o ro support is a
little broken.

I'll fix it up tonight, but the bug is in open_ctree if anyone gets
there first.  The MS_READONLY check gotos the wrong spot.

-chris


