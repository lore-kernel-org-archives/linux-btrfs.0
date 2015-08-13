Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:43704 "EHLO smtp2.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbbHMMVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 08:21:06 -0400
Received: from fex.belwue.de (fex.belwue.de [129.143.4.198])
	by smtp2.belwue.de with ESMTP id t7DC6wi1003121
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:06:58 +0200 (MEST)
	env-from (framstag@rus.uni-stuttgart.de)
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
	by fex.belwue.de (Postfix) with SMTP id EA4302036A
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:06:57 +0200 (CEST)
Date: Thu, 13 Aug 2015 14:06:57 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150813120657.GB24122@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC830D.2070304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CC830D.2070304@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 2015-08-13 (07:44), Austin S Hemmelgarn wrote:

> 2. Be _VERY_ careful using BTRFS on top of _ANY_ kind of shared storage. 
>   Most non-clustered filesystems will have issues if multiply mounted, 
> but in almost all cases I've personally seen, it _WILL_ cause 
> irreparable damage to a BTRFS filesystem (we really need to do something 
> like ext4's MMP in BTRFS).

Same with ZFS: it has also no MMP and when you mount a shared block device
twice you will destroy it irreparable. Kids, do not try this at home - I
have done so ;-)

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum IZUS/TIK         E-Mail: horlacher@tik.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<55CC830D.2070304@gmail.com>
