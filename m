Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760009Ab3ICRxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 13:53:04 -0400
Date: Tue, 3 Sep 2013 19:53:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: mkfs should check for small vol well
 before
Message-ID: <20130903175301.GC32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376657550-15011-1-git-send-email-anand.jain@oracle.com>
 <1377852637-4299-1-git-send-email-anand.jain@oracle.com>
 <20130830232233.GV23113@twin.jikos.cz>
 <52217F51.4000706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52217F51.4000706@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 31, 2013 at 01:29:53PM +0800, Anand Jain wrote:
>  Thanks for taking care of this David. Let me know if anywhere
>  needs more explanation.
>  I have been introducing series of device related changes in
>  btrfs-progs/mkfs which were/is essential bug fix. Fixes looks
>  complex since originally btrfs-progs/mkfs didn't create and
>  use much of helper functions in this area, now with these
>  fixes its much modular and better.

Yeah mkfs needs clean ups, thanks for doing that. I'm running btrfs/003
on top of various mkfs option combinations, so far it hasn't blown up at
mkfs time, the patches included are

btrfs-progs: mkfs should check for small vol well before
btrfs-progs: avoid write to the disk before sure to create fs

and excluded

btrfs-progs: mkfs.c overwrites fd without appropriate close
btrfs-progs: Fix: mkfs.c overwrites fd without appropriate close patch

david
