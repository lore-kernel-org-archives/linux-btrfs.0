Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46419 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752234AbcIAMYR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 08:24:17 -0400
Date: Thu, 1 Sep 2016 14:22:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] btrfs: fix perms on demonstration debugfs interface
Message-ID: <20160901122243.GO16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
 <13cedfd1-1eb2-6097-6f12-48e387042b9b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <13cedfd1-1eb2-6097-6f12-48e387042b9b@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 04:49:29PM -0500, Eric Sandeen wrote:
> btrfs provides a helpful demonstration of how to export
> a global variable via debugfs; however, it is unique among
> other debugfs files in that it is world-writable, which causes
> some concern to people who are not familiar with its purpose.
> 
> Fix it so that it is only user-writable.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: David Sterba <dsterba@suse.com>
