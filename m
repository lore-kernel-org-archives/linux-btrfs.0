Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54901 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbbFVUph (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 16:45:37 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.1
Date: Mon, 22 Jun 2015 22:45:32 +0200
Message-ID: <10252396.qecnRWx3hc@merkaba>
In-Reply-To: <20150622150023.GX6761@twin.jikos.cz>
References: <20150622150023.GX6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wow, nice collection of changes!

Am Montag, 22. Juni 2015, 17:00:23 schrieb David Sterba:
> * new
>   - rescure zero-log
>   - btrfsune:
>     - rewrite uuid on a filesystem image
>     - new option to turn on NO_HOLES incompat feature

Did you think about folding btrfstune into btrfs command as well?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
