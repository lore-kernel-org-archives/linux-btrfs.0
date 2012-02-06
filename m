From: David Sterba <dave@jikos.cz>
Subject: Re: subvolume info in /proc/mounts
Date: Mon, 6 Feb 2012 12:53:21 +0100
Message-ID: <20120206115321.GB15350@twin.jikos.cz>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr> <20120204214430.GA15350@twin.jikos.cz> <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org, kreijack@gmail.com,
	chris.mason@oracle.com
To: Nikos Voutsinas <nvoutsin@noc.edunet.gr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2ed5fe028fdcfd3d53cf217e13b827d9.squirrel@webmail01.edunet.gr>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 05, 2012 at 12:30:42PM +0200, Nikos Voutsinas wrote:
> It's quite old, but what was this about;
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/4487

Thanks, the patch looks ok and works as expected.

Goffredo, do you want to resend it? (The lock around the mnt_root is not
necessary.) I think it's a -rc material, more people came to ask about
this on irc channel lately, we don't need to wait a full release cycle
to merge this fix.


david
