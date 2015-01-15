Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50544 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbbAOUls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 15:41:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YBrEf-0004eQ-1b
	for linux-btrfs@vger.kernel.org; Thu, 15 Jan 2015 21:41:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 21:41:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 21:41:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: btrfs command completion  Was: [PATCH v2 RESEND] btrfs-progs: make
 btrfs qgroups show human readable sizes
Date: Thu, 15 Jan 2015 20:41:37 +0000 (UTC)
Message-ID: <pan$f88a$820e7cad$a184d636$bdb59ce2@cox.net>
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
	<20150114154633.GU3685@twin.jikos.cz> <54B71171.60809@cn.fujitsu.com>
	<20150115120546.GD3685@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 15 Jan 2015 13:05:46 +0100 as excerpted:

> A shell completion would be great of course, it's in the project ideas.
> There's a starting point
> http://www.spinics.net/lists/linux-btrfs/msg15899.html .

FWIW, in case anyone is interested...

What I did here is a bit different; shell completion would be better, but 
while I know bash, I don't know bash/shell completion so I couldn't write 
that without learning it.

What I did is a btrfs wrapper script (which I simply called 'b', a 
previously here-unused single letter command) that based on the first 
parameter or two and the number of parameters, decides if what's there 
matches a valid btrfs subcommand and whether it looks complete or not, 
and if it's valid but incomplete, echoes the appropriate btrfs <sub> help 
command and prompts for more input.

So just 'b' gives me:

------------------------------------------------------------
b: btrfs helper (common commands only)
------------------------------------------------------------
btrfs cmd (Just Enter for help):
b(alance) c(heck) d(ev) f(ilesystem) i(nspect) p(roperty)
qg(roup) qu(ota) rec(eive) rep(lace) resc(ue) rest(ore)
sc(rub) se(nd) su(bvolume) v(ersion):

There it waits for further input.

If I then add an 'f', or if I had typed 'b f' (or 'b fi' or
'b filesystem', the script checks status of btrfs <cmd> --help to see if 
it's valid or not), I get this:

f
------------------------------------------------------------
btrfs filesystem action (Just Enter for help):
de(frag) df l(abel) r(esize) sh(ow) sy(nc) u(sage):

Further input.

If I then add 'df' (or if I had typed 'b fi df'), I get:

df
------------------------------------------------------------
usage: btrfs filesystem df [options] <path>

    Show space usage information for a mount point

    -b|--raw           raw numbers in bytes
    -h                 human friendly numbers, base 1024 (default)
    -H                 human friendly numbers, base 1000
    --iec              use 1024 as a base (KiB, MiB, GiB, TiB)
    --si               use 1000 as a base (kB, MB, GB, TB)
    -k|--kbytes        show sizes in KiB, or kB with --si
    -m|--mbytes        show sizes in MiB, or MB with --si
    -g|--gbytes        show sizes in GiB, or GB with --si
    -t|--tbytes        show sizes in TiB, or TB with --si

------------------------------------------------------------
btrfs filesystem df usage is printed above.
Please enter additional parameters here:

Further input.

At this point it doesn't check further input, instead simply echoing back 
what will be the final command and prompting whether to run it or not.  
If I simply type '/'...

/
------------------------------------------------------------
btrfs filesystem df /
Final check: OK to run above command (y/N)?


Note the default to N...

If at that point I simply enter (or if I hit anything else besides y/Y), 
of course it doesn't run the command, it simply exits.  However, the 
built command was printed above, making it simple enough to select/paste 
(assuming gpm or a terminal window in X, thus mouse selection).

If I hit 'y', it executes the command.

Meanwhile, if there's more than two parameters and the first two 
validate, the script assumes the user knows what they are doing and 
simply executes it as-is.

b fi df /
------------------------------------------------------------
b: btrfs helper (common commands only)
------------------------------------------------------------
Data, RAID1: total=3.00GiB, used=1.74GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=768.00MiB, used=299.89MiB
GlobalReserve, single: total=48.00MiB, used=0.00B

b fi df invalid
------------------------------------------------------------
b: btrfs helper (common commands only)
------------------------------------------------------------
ERROR: can't access 'invalid'

b fxxx df /

This one's interesting.  The script checks the status of
btrfs fxxx --help and determines that btrfs doesn't consider the fxxx 
valid, so it simply prints the full btrfs --help output, running it thru 
$PAGER (if unset, less if it's executable, else no pager) due to length.


Anyone interested in a script such as this?  Absent a bash completion 
script, I found it /tremendously/ helpful with btrfs command basics, and 
because it prompts with the final command before execution, it helps in 
learning the commands as well.  I still use it for commands I don't use 
frequently enough to have memorized.  While it's a bit of a hack, thus my 
not posting it previously, if anyone else would find such a script 
useful, I could post it.

I don't have hosting for it but I suppose it could go on the wiki if 
enough other folks find it useful.  It's 125 lines including comments ATM.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

