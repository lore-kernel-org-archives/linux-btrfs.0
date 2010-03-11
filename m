From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: New btrfs command pushed into the btrfs-progs subvol branch - commands
Date: Thu, 11 Mar 2010 20:03:17 +0100
Message-ID: <201003112003.18245.kreijack@inwind.it>
References: <20100311185421.GM6509@think>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311185421.GM6509@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 11 March 2010, Chris Mason wrote:
> Hi everyone,
> 
> I've pushed Goffredo's new btrfs utility into the subvol branch of the
> btrfs-progs repo.  I'm using it as my starting point for the subvol
> listing utility as well as my fancy new defrag range ioctl.
> 
> Goffredo, the new defrag ioctl takes a bunch of arguments, and I used
> getopt inside the command to do it.  The tricky part is that getopt
> expects argv[0] to be the command name, so I had to hack things a bit.
> 
> Could you please send a patch that changes the commands to include the
> command name in argv[0]?  That'll make it easier to be flexible.
> 

I will start to work 

> -chris
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
