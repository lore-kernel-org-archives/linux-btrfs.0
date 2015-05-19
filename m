Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbbESJVi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 05:21:38 -0400
Date: Tue, 19 May 2015 11:21:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 linux-next] btrfs: use swap() in merge_ref()
Message-ID: <20150519092137.GF23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <1431969853-14700-1-git-send-email-fabf@skynet.be>
 <1431969853-14700-2-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431969853-14700-2-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 18, 2015 at 07:24:13PM +0200, Fabian Frederick wrote:
> Use kernel.h macro definition.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.cz>
