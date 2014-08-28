Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaH1Wtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 18:49:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XN8Vb-0007Ha-VC
	for linux-btrfs@vger.kernel.org; Fri, 29 Aug 2014 00:49:35 +0200
Received: from 11.161.185.203.dsl.dyn.mana.pf ([203.185.161.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Aug 2014 00:49:35 +0200
Received: from jd.girard by 11.161.185.203.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Aug 2014 00:49:35 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Undelete files / directory
Date: Thu, 28 Aug 2014 12:49:18 -1000
Message-ID: <ltoble$78t$1@ger.gmane.org>
References: <53FE1DB2.8040900@sysnux.pf> <4934565B-6B58-4ADA-BA16-50EC5D170F37@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <4934565B-6B58-4ADA-BA16-50EC5D170F37@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/08/2014 11:51, Chris Murphy a écrit :
> Ahh yes. So you'll see here that there's a new build for you not yet in updates repo.

btrfs-progs-3.16-1.fc20.x86_64 installed, but it doesn't change anything:

[jdg@tiare tmp]$ btrfs-find-root x220_home.img
Super think's the tree root is at 115230801920, chunk root 131072
Went past the fs size, exiting[jdg@tiare tmp]$


Thanks,
Jean-Denis Girard

