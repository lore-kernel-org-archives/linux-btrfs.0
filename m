From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Btrfs-progs: restriper interface
Date: Sat, 7 Jan 2012 13:48:44 +0100
Message-ID: <201201071348.45052.kreijack@inwind.it>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 06 January, 2012 15:37:59 Ilya Dryomov wrote:
> Hello,
> 
> This is an update of userspace restriper interface.  The main change is
> that restriper commands have been moved under balance prefix.  So now we
> have:
> 
> btrfs fi balance start
> btrfs fi balance pause
> btrfs fi balance cancel
> btrfs fi balance resume
> btrfs fi balance status
> 
> This breaks btrfs-progs backwards compatibility: to get the old
> balancing behaviour you have to call 'btrfs fi balance start' instead of
> 'btrfs fi balance'.  This is caused by stupidity of the core sub-command
> matcher.

Hi Ilya,

what you called "stupidity of the core sub-command matcher" was a design 
decision.

If you make "btrfs balance" a both command and a prefix you (my opinion) 
confuses a possible user and complex the interface:

for example what means:

# btrfs filesystem balance pause

when 'pause' (and all the valid abbreviation like "pa" or "p" ) is a valid 
mount point ?

My opinion, in order to not break the backward compatibility is to add another 
subcommand family, like 'restriper' or whatsoever, then deprecating the 
'balance' sub command.

Finally, please could you update the man page too ?

BR
G.Baroncelli

Disclaimer, I was the author of the sub-command matcher.

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
