Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53454 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2JBVIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 17:08:41 -0400
Date: Tue, 2 Oct 2012 17:08:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Wade Cline <clinew@linux.vnet.ibm.com>
Cc: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
Message-ID: <20121002210836.GA15277@thunk.org>
References: <506B31B7.40405@linux.vnet.ibm.com>
 <506B3A3E.1060003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506B3A3E.1060003@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 02, 2012 at 12:02:22PM -0700, Wade Cline wrote:
> Hello Theodore Ts'o,
> 
> Is there a function similar to ext2fs_dir_iterate2() that will call a hook
> function on an ext2_dir_entry_2 structure and not an ext2_dir_entry
> structure?
> 
> The reason I ask is because btrfs-convert currently tries to do a cast
> between the two structures as such:
> 
> 	static int dir_iterate_proc(..., struct ext2_dir_entry *old, ...)
> 	{
> 	...
> 		struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
> 
> which works fine on little-endian machines, but breaks on big-endian machines.

The reason why we don't have that function today is because what most
programs (especially inside e2fsprogs) have done is to use the
ext2_dir_entry structure and just simply used (name_len & 0xff) to get
the actual name length, and in the case of e2fsck (which is the only
program which in practice has cared about the file type) to get the
file type by doing (name_len >> 8).

> If there isn't, would you be interested in a patch that adds a
> function, say, ext2_dir_entry_upgrade(struct ext2_dir_entry *old,
> struct ext2_dir_entry_2 *new) that will convert one structure to the
> other and take into account the endianness of the machine? This
> would be better than just ad-hoc fixing the code in btrfs.

We could do that, but that would mean needing to copy the data
structure somewhere else, which means you would have to allocate
memory for the new data structure, and then you'd have to release that
memory later, etc.

I would think that using (name_len & 0xFF) is a much simpler solution,
and my suggestion is to not depend on the file type in the directory
entry (since there might be some very old ext2 file systems that don't
set the file type), and to use the inode's mode bits as authoratative
for the file type of the inode.

Regards,

							- Ted
    	
