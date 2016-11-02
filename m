Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755412AbcKBOau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 10:30:50 -0400
Date: Wed, 2 Nov 2016 15:30:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove some dead code
Message-ID: <20161102143046.GF12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 11:26:06AM +0100, Christophe JAILLET wrote:
> 'btrfs_iget()' can not return an error pointer, so this test can be
> removed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: David Sterba <dsterba@suse.com>
