Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964968AbeEIVhq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 17:37:46 -0400
Date: Wed, 9 May 2018 23:35:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Message-ID: <20180509213504.GC6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2018 at 11:01:21AM -0500, Eric Sandeen wrote:
> Move the btrfs label ioctls up to the vfs for general use.
> 
> This retains 256 chars as the maximum size through the interface, which
> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> label size.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The btrfs changes and new ioctl naming looks good to me,

Reviewed-by: David Sterba <dsterba@suse.com>
