Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52633 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2ISRjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 13:39:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: enquiry about autodefrag option
Date: Wed, 19 Sep 2012 19:39:42 +0200
Cc: Liu Bo <bo.li.liu@oracle.com>, ching <lsching17@gmail.com>
References: <50570652.4060200@gmail.com> <5059AC5E.1030003@gmail.com> <5059D2D3.3050303@oracle.com> (sfid-20120919_170608_234857_0DD33E13)
In-Reply-To: <5059D2D3.3050303@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209191939.43182.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 19. September 2012 schrieb Liu Bo:
> On 09/19/2012 07:28 PM, ching wrote:
[…]
> > On 09/17/2012 07:15 PM, ching wrote:
> >> I am testing btrfs for long-term storage and backup, and i would
> >> like to know more about "autodefrag" option:
> >> 
> >> 1. Will "autodefrag" option benefit ssd?
> >>
> >>     My understanding is:
> >>
> >>        autodrag -> number of extent decrease -> metadata decrease ->
> >>a
> >>
> >> "healthier" filesystem in the long run
> >>
> >>    (P.S. I am aware that autodefrag will introduce extra write I/O)
> 
> Yes, your understanding is right, random write workloads will benefit
> from it.

What about the extra I/O? And the greatly reduced seek times on SSDs?

Upto now I kept away from defragmenting on SSD.

I wonder about a good way to decide whether autodefrag makes things better 
or worse for a specific workload. What are the criteria on rotating media 
and what are they on SSD?


[… informational part about a BTRFS on SSD that should have an age of at 
least 8 months with almost daily upgrades  …]

I only have / running on SSD, but this since quite some time. And it does 
not seem to have gotten much worse – however this is only subjective 
feeling of performance.

Except for fstrim times. fstrim take way more time than in the beginning¹. 
So there seems to be free space fragmentation. Which makes sense for a 
root filesystem on a Debian Sid machine with lots of upgrade activity and 
way over 50% usage.

merkaba:~> df -hT /          
Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/dm-0      btrfs   19G     13G  3,6G   79% /

merkaba:~> btrfs fi sh       
failed to read /dev/sr0
Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 12.25GB
        devid    1 size 18.62GB used 18.62GB path /dev/dm-0

merkaba:~> btrfs fi df /
Data: total=15.10GB, used=11.58GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=688.96MB
Metadata: total=8.00MB, used=0.00

I think I get rid of that duplicate metadata once I redo the fs with 8 or 
16 KiB metadata blocks.

I thought about rebalancing it, but last time boot time doubled after a 
complete rebalance. The effect of a rebalance of just the metadata tree to 
one instead of two might be different tough.

Intel SSD 320 300GB on Kernel 3.6-rc5.


[1] It has been a second or two in the beginning I think. Then it grew 
over time.

merkaba:~> time fstrim -v /
/: 5877809152 bytes were trimmed
fstrim -v /  0,00s user 5,74s system 14% cpu 39,920 total
merkaba:~> time fstrim -v /
/: 5875712000 bytes were trimmed
fstrim -v /  0,00s user 5,55s system 14% cpu 39,095 total
merkaba:~> time fstrim -v /
/: 5875712000 bytes were trimmed
fstrim -v /  0,00s user 5,62s system 14% cpu 38,538 total

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
