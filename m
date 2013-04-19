Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43159 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3DSTl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 15:41:59 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: bo.li.liu@oracle.com
Subject: Re: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Fri, 19 Apr 2013 21:41:15 +0200
Cc: linux-btrfs@vger.kernel.org
References: <5157386.Pre7jntDtG@merkaba> <201304191115.30452.Martin@lichtvoll.de> <20130419115145.GB4949@liubo.jp.oracle.com> (sfid-20130419_212708_345466_52C9254F)
In-Reply-To: <20130419115145.GB4949@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304192141.15441.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 19. April 2013 schrieb Liu Bo:
> On Fri, Apr 19, 2013 at 11:15:30AM +0200, Martin Steigerwald wrote:
> > Am Dienstag, 16. April 2013 schrieb Martin Steigerwald:
> > > On Saturday 13 April 2013 17:48:31 Martin Steigerwald wrote:
> > > > Hi!
> > > > 
> > > > Please answer soon whether it would be a good idea to replay a
> > > > backup right now as I am leaving to Berlin tomorrow for a week
> > > > without my backup drive with me. Well, I made space on an external
> > > > 2,5 inch drive, that I can take with me. I am taking that one with
> > > > me, after having made sure it has a consistent backup. :)
> > > 
> > > Ping.
> > > 
> > > Any hints on this one? I am going to recreate the filesystem next
> > > weekend at latest.
> > > 
> > > I did not see any I/O or BTRFS errors in logs so far, so filesystem
> > > appears to be good.
> > 
> > Last chance to let me dig out some more information about this.
> > 
> > Even with lack of any other oddities I am not going to tolerate a non
> > scrubbing BTRFS filesystem for longer than a week and will redo it
> > during the weekend.
> 
> Hi Martin,
> 
> I think the bug is hidden back in the backtrace, any chance to get a
> btrfs-debug-tree output?

Yeah, of course. Grab it at:

http://martin-steigerwald.de/tmp/btrfs/

This is with 3.9-rc7.

Also noticed

Apr 13 16:35:21 merkaba kernel: [58720.288942] btrfs bad fsid on block 0

just now. Full kernel log uploaded there as well.


And I remember having done this:

# Thread: Re: btrfs crash when low on memory.
# Von: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
# An: Josef Bacik <jbacik@fusionio.com>
# Kopie: Dave Jones <davej@redhat.com>,
#        Linux Kernel <linux-kernel@vger.kernel.org>,
#        <linux-btrfs@vger.kernel.org>
# Datum: 27.02.2013 15:31
vm.min_free_kbytes = 200000


I had those BTRFS issues before doing the above. Maybe any corruption in
tree may have to do with that?




Got something on console despite piping stderr as well:

merkaba:~#130> btrfs-debug-tree /dev/merkaba/home > 
/home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ unable\ to\ find\ logical\ 
7599900409826160776\ len\ 16384/btrfs-debug-tree-2013-04-19.txt
parent transid verify failed on 223527043072 wanted 85915 found 85913
parent transid verify failed on 223527043072 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223570853888 wanted 85915 found 85913
parent transid verify failed on 223570853888 wanted 85915 found 85913
Ignoring transid failure
leaf parent key incorrect 223570853888
parent transid verify failed on 223570853888 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223564742656 wanted 85915 found 85913
parent transid verify failed on 223564742656 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223533858816 wanted 85915 found 85913
parent transid verify failed on 223533858816 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223565234176 wanted 85915 found 85913
parent transid verify failed on 223565234176 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223565807616 wanted 85915 found 85913
parent transid verify failed on 223565807616 wanted 85915 found 85913
Ignoring transid failure
zsh: abort      btrfs-debug-tree /dev/merkaba/home > 
merkaba:~#134> btrfs-debug-tree /dev/merkaba/home 2>&1 > 
/home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ unable\ to\ find\ logical\ 
7599900409826160776\ len\ 16384/btrfs-debug-tree-2013-04-19.txt
parent transid verify failed on 223527043072 wanted 85915 found 85913
parent transid verify failed on 223527043072 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223570853888 wanted 85915 found 85913
parent transid verify failed on 223570853888 wanted 85915 found 85913
Ignoring transid failure
leaf parent key incorrect 223570853888
parent transid verify failed on 223570853888 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223564742656 wanted 85915 found 85913
parent transid verify failed on 223564742656 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223533858816 wanted 85915 found 85913
parent transid verify failed on 223533858816 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223565234176 wanted 85915 found 85913
parent transid verify failed on 223565234176 wanted 85915 found 85913
Ignoring transid failure
parent transid verify failed on 223565807616 wanted 85915 found 85913
parent transid verify failed on 223565807616 wanted 85915 found 85913
Ignoring transid failure
zsh: abort      btrfs-debug-tree /dev/merkaba/home 2>&1 > 
merkaba:~#134> btrfs-debug-tree /dev/merkaba/home 2>&1 > 
/home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ unable\ to\ find\ logical\ 
7599900409826160776\ len\ 16384/btrfs-debug-tree-2013-04-19.txt
parent transid verify failed on 223588106240 wanted 85916 found 85913
parent transid verify failed on 223588106240 wanted 85916 found 85913
Ignoring transid failure
parent transid verify failed on 223547408384 wanted 85915 found 85913
parent transid verify failed on 223547408384 wanted 85915 found 85913
Ignoring transid failure
zsh: abort      btrfs-debug-tree /dev/merkaba/home 2>&1 > 
merkaba:~#134> btrfs-debug-tree /dev/merkaba/home 2>&1 > 
/home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ unable\ to\ find\ logical\ 
7599900409826160776\ len\ 16384/btrfs-debug-tree-2013-04-19.txt
parent transid verify failed on 223588106240 wanted 85916 found 85913
parent transid verify failed on 223588106240 wanted 85916 found 85913
Ignoring transid failure
parent transid verify failed on 223547408384 wanted 85915 found 85913
parent transid verify failed on 223547408384 wanted 85915 found 85913
Ignoring transid failure
zsh: abort      btrfs-debug-tree /dev/merkaba/home 2>&1 > 
merkaba:~#134> btrfs-debug-tree /dev/merkaba/home 2>&1 > 
/home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ unable\ to\ find\ logical\ 
7599900409826160776\ len\ 16384/btrfs-debug-tree-2013-04-19.txt
parent transid verify failed on 223588106240 wanted 85916 found 85913
parent transid verify failed on 223588106240 wanted 85916 found 85913
Ignoring transid failure
parent transid verify failed on 223547408384 wanted 85915 found 85913
parent transid verify failed on 223547408384 wanted 85915 found 85913
Ignoring transid failure
zsh: abort      btrfs-debug-tree /dev/merkaba/home 2>&1 > 
merkaba:~#134> ls -l /home/martin/Linux/Dateisysteme/BTRFS/Bugs/btrfs\ scrub\ gives\ btrfs:\ 
unable\ to\ find\ logical\ 7599900409826160776\ len\ 16384/


Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
