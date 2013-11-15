Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48179 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3KOLUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 06:20:34 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EFCCD9A06EE
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 04:20:33 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1384513869-24525-1-git-send-email-anand.jain@oracle.com>
CC: <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@libero.it>
References: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
 <1384513869-24525-1-git-send-email-anand.jain@oracle.com>
Message-ID: <20131115112027.3802.43139@localhost.localdomain>
Subject: Re: [PATCH v2] btrfs-progs: for mixed group check opt before default raid
 profile is enforced
Date: Fri, 15 Nov 2013 06:20:27 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Anand Jain (2013-11-15 06:11:09)
> This fixes the regression introduced with the patch
> 
>     btrfs-progs: avoid write to the disk before sure to create fs
> 
> what happened with this patch is it missed the check to see if the
> user has the option set before pushing the defaults.

Thanks Goffredo for tracking it down, and Anand for the quick fix.

-chris
