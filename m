Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbbCXWXp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 18:23:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YaXEb-0000E3-GT
	for linux-btrfs@vger.kernel.org; Tue, 24 Mar 2015 23:23:41 +0100
Received: from 214.102.200.146.dyn.plus.net ([146.200.102.214])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 23:23:41 +0100
Received: from just4pleisure by 214.102.200.146.dyn.plus.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 23:23:41 +0100
To: linux-btrfs@vger.kernel.org
From: Sophie <just4pleisure@gmail.com>
Subject: Re: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction (error
 -17)
Date: Tue, 24 Mar 2015 22:23:29 +0000
Message-ID: <meso51$cst$1@ger.gmane.org>
References: <CAPmwjs9EVi-vY7FEfm+U-CYuxMms2iB-0i6mMLShdJMO6pGYjQ@mail.gmail.com>	<merpmk$m16$1@ger.gmane.org> <1427218499.30561.0@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <1427218499.30561.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24/03/15 17:34, Chris Mason wrote:
>
>
> On Tue, Mar 24, 2015 at 9:43 AM, Sophie Dexter <Just4pLeisure@gmail.com>
> wrote:
>> On 20/03/2015 15:19, Sophie Dexter wrote:
>>> I'm given to understand that this is the right place to report a btrfs
>>> problem, I apologise if not :-(
>>>
>>> I have been using my router as a simple NFS NAS for around 2 years
>>> with an ext3 formatted 2 TB Western Digital 2.5" USB Passport disk. I
>>> have been slowly moving to BTRFS and thought it about time to convert
>>> this disk too but unfortunately BTRFS is unreliable on my router :-(.
>>> It doesn't take long for an error to happen causing a 'ro' remount.
>>> However the disk is unreadable after the remount, both for NFS and
>>> locally. Rebooting the router seems to be the only way to access the
>>> disk again.
>>>
>>> I also have a 1 GB swap partition on the disk although swap doesn't
>>> appear to be a factor as the problem occurs whether or not swap is
>>> enabled (this report is without swap).
>>>
>>> I used my laptop to convert the fs to btrfs, not my router. My laptop
>>> has Fedora 21 with 3.18 kernel and tools. No problems are found when I
>>> use my laptop to check and scrub the disk (i.e. with the disk
>>> connected directly to my laptop).
>
> You have great timing, there are two reports of a very similar abort
> with 4.0-rc5, but your report makes it clear these are not a regression
> from 4.0-rc4.
>
> Are you able to run btrfsck on this filesystem?  I'd like to check for
> metadata inconsistencies.
>
> -chris
>
Hi Chris,

Haha, great timing is the secret of good comedy lol

OpenWrt has only very recently signed off the 3.18 kernel as the default 
kernel for my router, I was using a build with 3.14 when I converted my 
disk and saw the same problem :!: I may have posted something I haven't 
repeated here in the OpenWrt ticket I opened:

https://dev.openwrt.org/ticket/19216

I previously checked and scrubbed the disk when the problem first 
occurred and happily no problems were found then. Although, I had to use 
another computer because btrfs check doesn't complete on my router, the 
process is killed due to lack of memory (btrfs invoked oom-killer) :-( 
Should I start another topic for this or just accept that that problem 
is due to a lack of memory?

I have just run btrfs check again using (yet another) laptop and I think 
everything is still OK:

# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: ########-####-####-####-############
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 930516788539 bytes used err is 0
total csum bytes: 1234353920
total tree bytes: 1458515968
total fs tree bytes: 54571008
total extent tree bytes: 66936832
btree space waste bytes: 73372568
file data blocks allocated: 1264250781696
  referenced 1264250781696
Btrfs v3.14.1
# uname -a
Linux ######-########-#### 3.16.0-31-generic #43-Ubuntu SMP Tue Mar 10 
17:37:36 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Kind regards,
Sophie x


