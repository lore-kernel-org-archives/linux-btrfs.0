Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbbIBPD2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 11:03:28 -0400
Date: Wed, 2 Sep 2015 17:02:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH 1/3] btrfs-progs: use calloc instead of malloc+memset for
 tree roots
Message-ID: <20150902150246.GN11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441131625.git.osandov@fb.com>
 <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 12:22:44PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

I'll apply that one now as it's independent on the feature. Thanks.
