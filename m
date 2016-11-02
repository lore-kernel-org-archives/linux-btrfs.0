Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbcKBOXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 10:23:43 -0400
Date: Wed, 2 Nov 2016 15:23:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <nickrterrell@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Call kunmap if zlib_inflateInit2 fails
Message-ID: <20161102142340.GE12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161102032527.62311-1-nickrterrell@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161102032527.62311-1-nickrterrell@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 08:25:27PM -0700, Nick Terrell wrote:
> If zlib_inflateInit2 fails, the input page is never unmapped.
> Add a call to kunmap when it fails.
> 
> Signed-off-by: Nick Terrell <nickrterrell@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
