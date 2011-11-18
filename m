From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Announcing btrfs-gui
Date: Fri, 18 Nov 2011 10:50:06 -0500
Message-ID: <4EC67EAE.2090602@cfl.rr.com>
References: <20110601232058.GA22619@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110601232058.GA22619@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 6/1/2011 7:20 PM, Hugo Mills wrote:
>     Over the last few weeks, I've been playing with a foolish idea,
> mostly triggered by a cluster of people being confused by btrfs's free
> space reporting (df vs btrfs fi df vs btrfs fi show). I also wanted an
> excuse, and some code, to mess around in the depths of the FS data
> structures.
>
>     Like all silly ideas, this one got a bit out of hand, and seems to
> have turned into something vaguely useful. I'm therefore pleased to
> announce the first major public release of btrfs-gui[1]: a point-and-
> click tool for managing btrfs filesystems.

This is a nice little tool.  The one suggestion that I have is that it 
display the actual chunks and where they are located.  It seems that 
right now it uses the same ioctl that btrfs fi df uses, and that just 
gets the total combined size for all chunks of a given type.  It would 
be nice if the gui actually parsed the chunk tree and showed each 
individual chunk with lines showing how they are mapped to the physical 
disks.

