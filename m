Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50817 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3BUTTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 14:19:41 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fails defragging
Date: Thu, 21 Feb 2013 20:18:49 +0100
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <51263363.9020203@petaramesh.org> (sfid-20130221_164628_363653_61E8E5F6)
In-Reply-To: <51263363.9020203@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302212018.49909.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 21. Februar 2013 schrieb Swâmi Petaramesh:
> Hi folks,
> 
> I'm using Ubuntu 12.10 Quantal with
> # uname -r
> 3.5.0-24-generic
> 
> And it seems I cannot defrag :
> 
> # filefrag /boot/initrd.img-3.5.0-24-generic
> /boot/initrd.img-3.5.0-24-generic: 3 extents found
> 
> # btrfs filesystem defrag /boot/initrd.img-3.5.0-24-generic
> # echo $?
> 20
> 
> # filefrag /boot/initrd.img-3.5.0-24-generic
> /boot/initrd.img-3.5.0-24-generic: 3 extents found
> 
> Any clue appreciated ;-)

Make sure to wait long enough or issue the "sync" command.

merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> ls -lh soprano-virtuoso.db  
-rw------- 1 martin martin 1,6G Feb 21 20:10 soprano-virtuoso.db
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> date ; filefrag soprano-virtuoso.db
Do 21. Feb 20:16:27 CET 2013
soprano-virtuoso.db: 58875 extents found
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> date ; btrfs fi defrag soprano-virtuoso.db 
Do 21. Feb 20:16:39 CET 2013
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend#20> date ; filefrag soprano-virtuoso.db       
Do 21. Feb 20:16:48 CET 2013
soprano-virtuoso.db: 22424 extents found
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> date ; filefrag soprano-virtuoso.db
Do 21. Feb 20:16:50 CET 2013
soprano-virtuoso.db: 22424 extents found
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> sync
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend> date ; filefrag soprano-virtuoso.db
Do 21. Feb 20:16:54 CET 2013
soprano-virtuoso.db: 960 extents found
merkaba:/home/martin/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend>

(here "fragmentation" might not be real fragmentation always due to the way
LZO compression works in BTRFS, AFAIR Hugo told me)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
