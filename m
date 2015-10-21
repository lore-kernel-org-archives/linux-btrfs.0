Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbbJUPEp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 11:04:45 -0400
Date: Wed, 21 Oct 2015 17:03:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Shan Hai <haishan.bai@hotmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs/file.c: remove an unsed varialbe first_index
Message-ID: <20151021150324.GI13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <BLU437-SMTP103CD3FBBD84F09E5592AACFF460@phx.gbl>
 <BLU437-SMTP103A5A3F35BD11388D6FC65FF460@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BLU437-SMTP103A5A3F35BD11388D6FC65FF460@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 21, 2015 at 11:40:57AM +0800, Shan Hai wrote:
> From: Shan Hai <shan.hai@windriver.com>
> 
> The commit b37392ea86761 ("Btrfs: cleanup unnecessary parameter
> and variant of prepare_pages()") makes it redundant.
> 
> Signed-off-by: Shan Hai <haishan.bai@hotmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
