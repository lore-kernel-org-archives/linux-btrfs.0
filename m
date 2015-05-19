Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbbESJVS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 05:21:18 -0400
Date: Tue, 19 May 2015 11:21:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 linux-next] btrfs: use swap() in __merge_refs
Message-ID: <20150519092116.GE23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <1431969853-14700-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431969853-14700-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 18, 2015 at 07:24:12PM +0200, Fabian Frederick wrote:
> Use kernel.h macro definition.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.cz>
