Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755504AbeDWPSw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 11:18:52 -0400
Date: Mon, 23 Apr 2018 17:16:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: status page
Message-ID: <20180423151618.GY21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJH6TXhQA-yx1kE2CJLboxMyay+54qb9DxiRZkNrGhsPP8LkXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 06:24:29PM +0200, Gandalf Corvotempesta wrote:
> Hi to all,
> as kernel 4.16 is out and 4.17 in in RC, would be possible to update
> BTRFS status page
> https://btrfs.wiki.kernel.org/index.php/Status to reflect 4.16 stability ?
> 
> That page is still based on kernel 4.15 (marked as EOL here:
> https://www.kernel.org/)

Reviewed and updated for 4.16, there's no change regarding the overall
status, though 4.16 has some raid56 fixes.
