Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705Ab3CZNXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 09:23:33 -0400
Date: Tue, 26 Mar 2013 14:23:29 +0100
From: Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: document mount options in
 Documentation/fs/btrfs.txt
Message-ID: <20130326132329.GC801@x2.net.home>
References: <514DEB06.7000606@redhat.com>
 <20130324003321.7f119e91@natsu>
 <514DF850.5080906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <514DF850.5080906@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 23, 2013 at 01:45:36PM -0500, Eric Sandeen wrote:
> The mount manpage is maintained in the util-linux pkg,
> but it's not kernel-version specific, and the util-linux
> maintainer does not have specific knowledge of all filesytem
> options.

Absolutely true. The util-linux maintainer is not happy that we 
don't have filesystem specific man pages for many filesystems.

The goal is to have in mount.8 only links to another man pages, for
example see smart NFS guys:

  Mount options for nfs and nfs4:
       See the options section of the nfs(5) man page (nfs-utils
       package must be installed).

  
> I think kernel docs are the right place for the developers
> to first document these things

 Definitely.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
