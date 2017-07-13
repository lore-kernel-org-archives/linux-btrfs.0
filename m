Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48455 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751384AbdGMAJf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 20:09:35 -0400
Date: Thu, 13 Jul 2017 02:08:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v3 13/13] btrfs: clean up extraneous computations in
 add_delayed_refs
Message-ID: <20170713000821.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712222011.26705-1-enadolski@suse.com>
 <20170712222011.26705-7-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712222011.26705-7-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 04:20:11PM -0600, Edmund Nadolski wrote:
> Repeating the same computation in multiple places is not
> necessary.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
