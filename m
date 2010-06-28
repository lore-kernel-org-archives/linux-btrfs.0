From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Mon, 28 Jun 2010 13:48:01 +0000 (UTC)
Message-ID: <loom.20100628T154422-48@post.gmane.org>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net> <20100602155646.GA4041@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sean Bartell <wingedtachikoma <at> gmail.com> writes:

> > Is there a more aggressive filesystem restorer than btrfsck?  It simply
> > gives up immediately with the following error:
> > 
> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
> > failed.
> 
> btrfsck currently only checks whether a filesystem is consistent. It
> doesn't try to perform any recovery or error correction at all, so it's
> mostly useful to developers. Any error handling occurs while the
> filesystem is mounted.
> 

Is there any plan to implement this functionality. It would seem to me to be a 
pretty basic feature that is missing ? 


