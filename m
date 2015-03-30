Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43813 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbbC3OGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 10:06:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcaKD-00049o-Kl
	for linux-btrfs@vger.kernel.org; Mon, 30 Mar 2015 16:05:57 +0200
Received: from 214.102.200.146.dyn.plus.net ([146.200.102.214])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 16:05:57 +0200
Received: from Just4pLeisure by 214.102.200.146.dyn.plus.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 16:05:57 +0200
To: linux-btrfs@vger.kernel.org
From: Sophie Dexter <Just4pLeisure@gmail.com>
Subject: Re: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction (error
 -17)
Date: Mon, 30 Mar 2015 15:05:05 +0100
Message-ID: <mfbl7d$fsr$1@ger.gmane.org>
References: <CAPmwjs9EVi-vY7FEfm+U-CYuxMms2iB-0i6mMLShdJMO6pGYjQ@mail.gmail.com>	<merpmk$m16$1@ger.gmane.org> <1427218499.30561.0@mail.thefacebook.com> <meso51$cst$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <meso51$cst$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 24/03/15 17:34, Chris Mason wrote:
>> You have great timing, there are two reports of a very similar abort
>> with 4.0-rc5, but your report makes it clear these are not a regression
>> from 4.0-rc4.
>>
>> Are you able to run btrfsck on this filesystem?  I'd like to check for
>> metadata inconsistencies.
>>
>> -chris
>>
> Hi Chris,
>
> Haha, great timing is the secret of good comedy lol
>
> OpenWrt has only very recently signed off the 3.18 kernel as the default
> kernel for my router, I was using a build with 3.14 when I converted my
> disk and saw the same problem :!: I may have posted something I haven't
> repeated here in the OpenWrt ticket I opened:
>
> https://dev.openwrt.org/ticket/19216
>
> I previously checked and scrubbed the disk when the problem first
> occurred and happily no problems were found then. Although, I had to use
> another computer because btrfs check doesn't complete on my router, the
> process is killed due to lack of memory (btrfs invoked oom-killer) :-(
> Should I start another topic for this or just accept that that problem
> is due to a lack of memory?
>
> I have just run btrfs check again using (yet another) laptop and I think
> everything is still OK:
>
> # btrfs check /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: ########-####-####-####-############
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 930516788539 bytes used err is 0
> total csum bytes: 1234353920
> total tree bytes: 1458515968
> total fs tree bytes: 54571008
> total extent tree bytes: 66936832
> btree space waste bytes: 73372568
> file data blocks allocated: 1264250781696
>   referenced 1264250781696
> Btrfs v3.14.1
> # uname -a
> Linux ######-########-#### 3.16.0-31-generic #43-Ubuntu SMP Tue Mar 10
> 17:37:36 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> Kind regards,
> Sophie x
>
>
I want to continue to use BTRFS as far as possible and have moved this 
disk to a Raspberry Pi now because of the problems I encountered with it 
when it was plugged into my router. I'd rather do this than convert back 
to ext3/4. I'm using Open Media Vault on my Paspberry Pi and, fingers 
crossed, haven't had any problems over the weekend.

I can only guess, given it's inability to complete a btrfs check, that a 
router doesn't have enough memory for BTRFS. I'm happy to move my disk 
back to my router to try things out and help develop BTRFS for small 
computers, but for now at least it has a new home.

Sophie x

