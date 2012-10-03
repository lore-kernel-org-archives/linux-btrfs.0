Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53610 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965399Ab2JCR6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 13:58:36 -0400
Date: Wed, 3 Oct 2012 13:58:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Wade Cline <clinew@linux.vnet.ibm.com>
Cc: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
Message-ID: <20121003175831.GC4237@thunk.org>
References: <506B31B7.40405@linux.vnet.ibm.com>
 <506B3A3E.1060003@linux.vnet.ibm.com>
 <20121002210836.GA15277@thunk.org>
 <506C786B.4080704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506C786B.4080704@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 10:39:55AM -0700, Wade Cline wrote:
> >I would think that using (name_len&  0xFF) is a much simpler solution,
> >and my suggestion is to not depend on the file type in the directory
> >entry (since there might be some very old ext2 file systems that don't
> >set the file type), and to use the inode's mode bits as authoratative
> >for the file type of the inode.
> >
>
> Interesting compatibility issue. Will keep it in mind.

To clarify, the EXT2_FEATURE_INCOMPAT_FILETYPE flag indicates that
there _may_ be file type information in the directory entry (and so
only the low 8 bits of name_len should be considered part of the name
length), but it does not guarantee that it will be present in the high
8 bits of name_len.

If it is not there, then readdir will simply return DT_UNKNOWN in the
d_type field of the directory entry returned by readdir(2).  This is
something all application programs have to be prepared to deal with
--- if they need the file type information, and they get DT_UNKNOWN,
then they will need to stat the file to get the information.

	     	     	      	     - Ted
