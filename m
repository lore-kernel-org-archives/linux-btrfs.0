Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3EETl5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 15:41:57 -0400
Date: Sun, 5 May 2013 20:41:51 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Development discussions related to Fedora
	<devel@lists.fedoraproject.org>
Cc: test@lists.fedoraproject.org, linux-btrfs@vger.kernel.org
Subject: Re: rawhide report: 20130505 changes
Message-ID: <20130505194151.GD25815@redhat.com>
References: <20130505112617.GA16141@releng03.phx2.fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130505112617.GA16141@releng03.phx2.fedoraproject.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 11:26:17AM +0000, Fedora Rawhide Report wrote:
> [libguestfs]
> 	1:libguestfs-1.21.36-1.fc20.i686 requires libbtrfs.so.0
> 	1:libguestfs-1.21.36-1.fc20.x86_64 requires libbtrfs.so.0()(64bit)

I've started a rebuild of libguestfs which should fix this.

Is there any significance to the soname change?  Is libbtrfs.so an
internal implementation detail or a public API?  (I don't have this
library on Fedora 18).  And if it's a public API will any software
need source-level changes to accomodate this bump?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
