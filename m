Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751088AbdE2PeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:34:10 -0400
Date: Mon, 29 May 2017 17:33:08 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Introduce btrfs_check_namelen to avoid
 reading beyond boundary
Message-ID: <20170529153308.GN14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
 <20170529152243.GL14523@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170529152243.GL14523@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 29, 2017 at 05:22:43PM +0200, David Sterba wrote:
> On Thu, May 25, 2017 at 10:09:06AM +0800, Su Yue wrote:
> > When reading out name from inode_ref, dir_item, it's possible that
> > corrupted name_len lead to read beyond boundary.
> > 
> > Since there are already patches for btrfs-progs, this is for btrfs.
> > 
> > Introduce function btrfs_check_namelen, it should be called before reading
> > name from extent_buffer.
> > The function compares arg @namelen with boundary then returns 'proper'
> > namelen.
> > 
> > Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Such validation is useful, but I'm concerned about the proposed
> implementation and usage pattern.

After reading the other patches again, I think the function name can
stay but will return bool and verifies if the namelen parameter matches
the verified value. That way you can get rid of all the local variables
and checks everywhere.

That way the additional check won't be missed like in this hunk from
patch 3:

@@ -976,9 +980,11 @@  static noinline int backref_in_log(struct btrfs_root *log,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		ref = (struct btrfs_inode_ref *)ptr;
+		name_ptr = (unsigned long)(ref + 1);
 		found_name_len = btrfs_inode_ref_name_len(path->nodes[0], ref);
+		namelen_ret = btrfs_check_namelen(path->nodes[0],
+				path->slots[0], name_ptr, found_name_len);
 		if (found_name_len == namelen) {
-			name_ptr = (unsigned long)(ref + 1);
 			ret = memcmp_extent_buffer(path->nodes[0], name,
 						   name_ptr, namelen);
 			if (ret == 0) {

namelen_ret is set but unused.
