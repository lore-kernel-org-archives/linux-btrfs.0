Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaEINkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 09:40:04 -0400
Date: Fri, 9 May 2014 15:40:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: return ptr error from compression workspace
Message-ID: <20140509134003.GB5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <1399590979-15331-2-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399590979-15331-2-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 07:16:18PM -0400, Zach Brown wrote:
> The btrfs compression wrappers translated errors from workspace
> allocation to either -ENOMEM or -1.  The compression type workspace
> allocators are already returning a ERR_PTR(-ENOMEM).  Just return that
> and get rid of the magical -1.
> 
> This helps a future patch return errors from the compression wrappers.
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
