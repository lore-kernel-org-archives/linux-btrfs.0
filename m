From: andrew henry <adhenry.9@gmail.com>
Subject: Re: online snapshots of subvolumes?
Date: Sun, 19 Feb 2012 17:01:15 +0100
Message-ID: <4F411CCB.1090400@gmail.com>
References: <4F40EF5F.1010404@gmail.com> <20120219130952.GC17761@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120219130952.GC17761@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/19/2012 02:09 PM, Hugo Mills wrote:
> You don't need to unmount the subvolume. Linux allows you to mount a
> filesystem in multiple places at one. With the ability to mount
> subvolumes separately in btrfs, this means that you can mount the top
> level (subvolid=0) somewhere temporarily without having to unmount
> anything else. Hugo. 
Thanks for the clarification!

Andrew

