Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3LQRlC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 12:41:02 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1387300065.15080.6.camel@ret.masoncoding.com>
References: <1387300065.15080.6.camel@ret.masoncoding.com> <14884.1387299196@warthog.procyon.org.uk>
To: Chris Mason <clm@fb.com>
Cc: dhowells@redhat.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "simonxwilkinson@gmail.com" <simonxwilkinson@gmail.com>,
        "jaltman@your-file-system.com" <jaltman@your-file-system.com>,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>
Subject: Re: What is needed to build an AFS fileserver on top of BTRFS?
Date: Tue, 17 Dec 2013 17:40:45 +0000
Message-ID: <17653.1387302045@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <clm@fb.com> wrote:

> Hmmm, what exactly are vnodes?  Could we put them in xattrs?

vnode numbers are AFS's equivalent of inode numbers.  Since they're one per
file, they could be the object filename.

Probably there would have to be a table of {vnode,latest_uniquifier} as the
uniquifier must still go up even if the vnode is unused for a while, so there
could also be a table of {vnode,btrfs_file}.

David
