From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Damaged super block / fs root
Date: Mon, 30 May 2011 15:03:36 -0400
Message-ID: <1306782166-sup-3731@shiny>
References: <4DE3BEFA.7080106@ftml.net> <20110530161216.GA8002@carfax.org.uk> <4DE3CA05.6020709@ftml.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dennis Bergmann <d.bergmann@ftml.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DE3CA05.6020709@ftml.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Dennis Bergmann's message of 2011-05-30 12:47:01 -0400:
> On 30.05.2011 18:12, Hugo Mills wrote:
> >     You can check whether it's likely to be of use by running "btrfsck
> > -s 1" on your filesystem. If it passes OK, then btrfs-select-super
> > should be useful.
> >
> >     Hugo.
> 
> Didn't work, unfortunately.
> 
> My btrfsck version is v0.19-35-g1b444cd-dirty and running
> "btrfsck -s 1 /dev/sda5" quits with the following message:
> 
> using SB copy 1, bytenr 67108864
> No valid Btrfs found on /dev/sda5
> 

How big is the FS?  What command did you use to overwrite the super
block?  Please try to tell us exactly which commands were run.

There are other ways we can try to pull things off, but you should try
btrfsck -s 2 as well.

-chris
