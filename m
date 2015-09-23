Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbbIWIsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 04:48:45 -0400
Date: Wed, 23 Sep 2015 10:47:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: check-integrity: Fix returned errno codes
Message-ID: <20150923084749.GS12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442939007.git.luis@debethencourt.com>
 <311df0a5aadcb7578746ad7d0107045f6fcf43a1.1442939007.git.luis@debethencourt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <311df0a5aadcb7578746ad7d0107045f6fcf43a1.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 05:29:38PM +0100, Luis de Bethencourt wrote:
> check-integrity is using -1 instead of the -ENOMEM defined macro to
> specify that a buffer allocation failed. Since the error number is
> propagated, the caller will get a -EPERM which is the wrong error
> condition.

Agreed. btrfsic_process_superblock can be called from the mount path so
getting EPERM would be confusing.

> Also, the smatch tool complains with the following warnings:
> btrfsic_process_superblock() warn: returning -1 instead of -ENOMEM is sloppy
> btrfsic_read_block() warn: returning -1 instead of -ENOMEM is sloppy
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Reviewed-by: David Sterba <dsterba@suse.com>
