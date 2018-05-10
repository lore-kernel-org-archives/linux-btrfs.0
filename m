Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54640 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbeEJTQM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 15:16:12 -0400
Date: Thu, 10 May 2018 20:16:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Message-ID: <20180510191608.GR30522@ZenIV.linux.org.uk>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
 <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 01:13:57PM -0500, Eric Sandeen wrote:
> Move the btrfs label ioctls up to the vfs for general use.
> 
> This retains 256 chars as the maximum size through the interface, which
> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> label size.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: David Sterba <dsterba@suse.com>

No objections (and it obviously ought to go through btrfs tree).
