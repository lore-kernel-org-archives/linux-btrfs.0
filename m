Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34679 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbcGGCZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 22:25:42 -0400
Received: by mail-wm0-f53.google.com with SMTP id 187so295598wmz.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 19:24:58 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <CAJCQCtTvzBFby+n5uV4dHYH38nuh8AS_sBLNSdQOyixeoK+QCw@mail.gmail.com>
Date: Thu, 7 Jul 2016 03:24:55 +0100
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <2AF0A937-86CC-48B0-AA6B-834BB04BB726@gmail.com>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com> <CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com> <EDF51D2D-A311-47DF-BFF7-F5C855B9E96D@gmail.com> <CAPmG0jaUz1JeRiu_cAqQXM-mAhBcTLKrmxfTu=OqcrHLBRLA+A@mail.gmail.com> <0EBF76CB-A350-4108-91EF-076A73932061@gmail.com> <CAPmG0jaUeisyZD6eApjaf=e3OdTaCWFDCoT_8Msc1HUadyNWug@mail.gmail.com> <EE95D9F3-84A2-4F45-B1FE-D54557374EF3@gmail.com> <20160707012246.3559fd0a@jupiter.sol.kaishome.de> <CAJCQCtTvzBFby+n5uV4dHYH38nuh8AS_sBLNSdQOyixeoK+QCw@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 7 Jul 2016, at 02:46, Chris Murphy <lists@colorremedies.com> wrote:
> 

Chaps, I didn’t wanted this to spring up as a performance of btrfs argument,

BUT 

you are throwing a lot of useful data, maybe diverting some of it into wiki ? you know, us normal people might find it useful for making educated choice in some future ? :)

Interestingly on my RAID10 with 6 disks I only get:

dd if=/mnt/share/asdf of=/dev/zero bs=100M
113+1 records in
113+1 records out
11874643004 bytes (12 GB, 11 GiB) copied, 45.3123 s, 262 MB/s


filefrag -v
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    2471: 2101940598..2101943069:   2472:            
   1:     2472..   12583: 1938312686..1938322797:  10112: 2101943070:
   2:    12584..   12837: 1937534654..1937534907:    254: 1938322798:
   3:    12838..   12839: 1937534908..1937534909:      2:            
   4:    12840..   34109: 1902954063..1902975332:  21270: 1937534910:
   5:    34110..   53671: 1900857931..1900877492:  19562: 1902975333:
   6:    53672..   54055: 1900877493..1900877876:    384:            
   7:    54056..   54063: 1900877877..1900877884:      8:            
   8:    54064..   98041: 1900877885..1900921862:  43978:            
   9:    98042..  117671: 1900921863..1900941492:  19630:            
  10:   117672..  118055: 1900941493..1900941876:    384:            
  11:   118056..  161833: 1900941877..1900985654:  43778:            
  12:   161834..  204013: 1900985655..1901027834:  42180:            
  13:   204014..  214269: 1901027835..1901038090:  10256:            
  14:   214270..  214401: 1901038091..1901038222:    132:            
  15:   214402..  214407: 1901038223..1901038228:      6:            
  16:   214408..  258089: 1901038229..1901081910:  43682:            
  17:   258090..  300139: 1901081911..1901123960:  42050:            
  18:   300140..  310559: 1901123961..1901134380:  10420:            
  19:   310560..  310695: 1901134381..1901134516:    136:            
  20:   310696..  354251: 1901134517..1901178072:  43556:            
  21:   354252..  396389: 1901178073..1901220210:  42138:            
  22:   396390..  406353: 1901220211..1901230174:   9964:            
  23:   406354..  406515: 1901230175..1901230336:    162:            
  24:   406516..  406519: 1901230337..1901230340:      4:            
  25:   406520..  450115: 1901230341..1901273936:  43596:            
  26:   450116..  492161: 1901273937..1901315982:  42046:            
  27:   492162..  524199: 1901315983..1901348020:  32038:            
  28:   524200..  535355: 1901348021..1901359176:  11156:            
  29:   535356..  535591: 1901359177..1901359412:    236:            
  30:   535592.. 1315369: 1899830240..1900610017: 779778: 1901359413:
  31:  1315370.. 1357435: 1901359413..1901401478:  42066: 1900610018:
  32:  1357436.. 1368091: 1928101070..1928111725:  10656: 1901401479:
  33:  1368092.. 1368231: 1928111726..1928111865:    140:            
  34:  1368232.. 2113959: 1899043808..1899789535: 745728: 1928111866:
  35:  2113960.. 2899082: 1898257376..1899042498: 785123: 1899789536: last,elf


If it would be possible to read from 6 disks at once maybe this performance would be better for linear read.

Anyway this is a huge diversion from original question, so maybe we will end here ?


