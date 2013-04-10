Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934984Ab3DJPRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 11:17:18 -0400
Date: Wed, 10 Apr 2013 17:17:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allow file data clone within a file
Message-ID: <20130410151716.GO18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365344298-23917-1-git-send-email-bo.li.liu@oracle.com>
 <20130408124918.GB18193@twin.jikos.cz>
 <20130408135643.GA27988@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408135643.GA27988@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 09:56:44PM +0800, Liu Bo wrote:
> Yeah, that's right, I missed this, what about another sanity check for
> overlapping ranges, of course in the case of the same file?

Yes of course, I can't work right without it.

david
