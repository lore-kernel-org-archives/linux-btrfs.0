Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10387 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab3LQRHw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 12:07:52 -0500
From: Chris Mason <clm@fb.com>
To: "dhowells@redhat.com" <dhowells@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "simonxwilkinson@gmail.com" <simonxwilkinson@gmail.com>,
        "jaltman@your-file-system.com" <jaltman@your-file-system.com>,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>
Subject: Re: What is needed to build an AFS fileserver on top of BTRFS?
Date: Tue, 17 Dec 2013 17:07:38 +0000
Message-ID: <1387300065.15080.6.camel@ret.masoncoding.com>
References: <14884.1387299196@warthog.procyon.org.uk>
In-Reply-To: <14884.1387299196@warthog.procyon.org.uk>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-12-17 at 16:53 +-0000, David Howells wrote:
+AD4- It has occurred to me and others that something like BTRFS could be a good fit
+AD4- to build an AFS fileserver directly on top of.  The question is what facilities
+AD4- would be needed from BTRFS to make this work?
+AD4- 
+AD4- So I thought I'd kick off a shopping list+ADs--)
+AD4- 
+AD4-  (1) 64-bit data version numbers that increase monotonically with each write.
+AD4- 
+AD4-      Yes, this is likely to cause some performance degredation as it introduces
+AD4-      an ordering over data writes and metadata writes to a file.  Maybe writes
+AD4-      can be batched to improve performance?
+AD4-
+AD4-  (2) Storage for ACLs and AFS UIDs.  Having shareable ACLs might also be useful.
+AD4- 
+AD4-      Xattrs would likely do for this.
+AD4- 
+AD4-  (3) The ability to snapshot a filesystem to make backups and for pushing to
+AD4-      read-only volume servers.
+AD4- 
+AD4-  (4) A 32-bit vnode number and 32-bit vnode uniquifier/generation number.
+AD4- 
+AD4-      These don't necessarily have to be stored by BTRFS directly but could
+AD4-      instead be in a separate database file that gets snapshotted also.
+AD4- 
+AD4-  (5) The ability to set the vnode number, vnode uniquifier and data version
+AD4-      number to specific values.  Necessary to clone volumes and restore
+AD4-      volume dumps.

Hmmm, what exactly are vnodes?  Could we put them in xattrs?

-chris


