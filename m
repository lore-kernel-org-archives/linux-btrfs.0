From: Kyle Gates <kylegates@hotmail.com>
Subject: RE: Set nodatacow per file?
Date: Wed, 29 Feb 2012 09:09:28 -0600
Message-ID: <COL113-W608CD6CB84D365D60C7B7FB06F0@phx.gbl>
References: <4F38B8F0.5020506@yahoo.com>
 <4F38BE53.4080204@parallels.com>,<20120213141040.GG15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213141040.GG15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>



> > Actually it is possible. Check out David's response to my question from
> > some time ago:
> > http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>
> this was a quick aid, please see attached file for an updated tool to set
> the file flags, now added 'z' for NOCOMPRESS flag, and supports chattr
> syntax plus all of the standard file flags.
>
> Setting and unsetting nocow is done like 'fileflags +C file' or -C for
> unseting. Without any + or - options it prints current state.


I get the following errors when running fileflags on large (>2GB) database files:

open(): No such file or directory

open(): Value too large for defined data type


 		 	   		  