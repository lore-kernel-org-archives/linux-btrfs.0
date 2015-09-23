Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbIWIv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 04:51:29 -0400
Date: Wed, 23 Sep 2015 10:50:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Luis de Bethencourt <luis@debethencourt.com>,
        clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: Fix returned errno codes
Message-ID: <20150923085033.GT12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442939007.git.luis@debethencourt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 05:29:37PM +0100, Luis de Bethencourt wrote:
> These two patches fix instances where -1 is used to specify a buffer
> allocation fail, instead of using -ENOMEM.
> 
> I could merge the two patches into one if that's more appropriate.

No, it's better to change them separately. If you change the return
value, also look at all the callers so you can see the impact of the
change and count that into the "size of the patch".
