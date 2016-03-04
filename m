Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbcCDS5e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 13:57:34 -0500
Date: Fri, 4 Mar 2016 19:57:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Ondrej Kozina <okozina@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: libbtrfs: remove max/min macros from API
Message-ID: <20160304185717.GC30625@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457099171-24095-1-git-send-email-okozina@redhat.com>
 <1457099171-24095-2-git-send-email-okozina@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457099171-24095-2-git-send-email-okozina@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 04, 2016 at 02:46:11PM +0100, Ondrej Kozina wrote:
> kerncompat.h header file is part of libbtrfs API. min/max macros cause
> conflict while building projects dependant on libbtrfs. Moving those
> macros to btrfs-progs internal header file fixes the conflict.
> 
> Signed-of-by: Ondrej Kozina <okozina@redhat.com>

Applied, thanks.
