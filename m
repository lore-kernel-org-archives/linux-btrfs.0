Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932187AbcKGQTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 11:19:31 -0500
Date: Mon, 7 Nov 2016 17:19:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] btrfs: Remove some dead code
Message-ID: <20161107161927.GP12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161104070235.12975-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161104070235.12975-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 08:02:35AM +0100, Christophe JAILLET wrote:
> 'btrfs_iget()' can not return NULL, so this test can be removed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch replaced, I've edited the subject to be a bit more specific.
