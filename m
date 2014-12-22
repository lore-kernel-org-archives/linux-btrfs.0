Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaLVRcI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 12:32:08 -0500
Date: Mon, 22 Dec 2014 18:32:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][CLEANUP] Remove gotos
Message-ID: <20141222173205.GD6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419185238-4254-1-git-send-email-kreijack@inwind.it>
 <1419185238-4254-2-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419185238-4254-2-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

... Subject: [PATCH][BTRFS-PROGS][CLEANUP] Remove gotos

You're being too creative with the subjects and lack the preferred
formatting. If you're going to submit more patches, please get it right
so I don't have to fix it repeatedly manually. There's a wiki page

 https://btrfs.wiki.kernel.org/index.php/Developer's_FAQ

that should cover the topic.

On Sun, Dec 21, 2014 at 07:07:18PM +0100, Goffredo Baroncelli wrote:
> Change a spagetti-style code (there are some "interlaced" gotos) to
> a more modern style...
> 
> This patch removes also some #define from utils.h, which define
> constants used only in cmds-filesystems.c . Instead an enum
> is used locally in cmds-filesystems.c .

That's an unrelated change, please put it into a separate patch.
