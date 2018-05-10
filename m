Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935568AbeEJOOY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 10:14:24 -0400
Date: Thu, 10 May 2018 16:11:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v2 2/8] btrfs: rename btrfs_mask_flags to reflect which
 flags it touches
Message-ID: <20180510141144.GJ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1525873677.git.dsterba@suse.com>
 <e25035869a53c49266de464621a92184546750d5.1525873677.git.dsterba@suse.com>
 <9f861bbe-1642-f560-bab9-f1e29fa748ab@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9f861bbe-1642-f560-bab9-f1e29fa748ab@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 09:38:12AM +0300, Nikolay Borisov wrote:
> On  9.05.2018 16:54, David Sterba wrote:
> > The FS_*_FL flags cannot be easily identified by a variable name prefix
> > but we still need to recognize them so the 'fsflags' should be closer to
> > the naming scheme but again the 'fs' part sounds like it's a filesystem
> > flag. I don't have a better idea for now.
> 
> Why not using iflags, my reasoning is that the official documentation of
> those flags: http://man7.org/linux/man-pages/man2/ioctl_iflags.2.html
> refers to them as "inode flags" hence iflags or the slightly longer
> inode_flags?

The first patch tries to capture the inode flags name for the btrfs
inode ... "The btrfs inode flag flavour is now simply called 'inode
flags'"

The manual page talks only about one ioctl and namespace, but in the
code we have to deal with several. I'm not happy about the naming, but
at least it's obvious which namespace is used.
