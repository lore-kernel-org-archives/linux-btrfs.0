Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbIYKlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 06:41:55 -0400
Date: Fri, 25 Sep 2015 12:40:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: reada: Fix returned errno code
Message-ID: <20150925104056.GD11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443121865.git.luisbg@osg.samsung.com>
 <cae144357b99745472aad5d3e98acb8028bfb2ee.1443121865.git.luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cae144357b99745472aad5d3e98acb8028bfb2ee.1443121865.git.luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2015 at 08:13:33PM +0100, Luis de Bethencourt wrote:
> reada is using -1 instead of the -ENOMEM defined macro to specify that
> a buffer allocation failed. Since the error number is propagated, the
> caller will get a -EPERM which is the wrong error condition.
> 
> Also, updating the caller to return the exact value from
> reada_add_block.
> 
> Smatch tool warning:
> reada_add_block() warn: returning -1 instead of -ENOMEM is sloppy
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Reviewed-by: David Sterba <dsterba@suse.com>
