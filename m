Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab2EVNcK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 09:32:10 -0400
Date: Tue, 22 May 2012 09:31:52 -0400
From: Josef Bacik <josef@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, Martin Mailand <martin@tuxadero.com>,
        Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120522133152.GA1890@localhost.localdomain>
References: <4FB4D30C.7030301@tuxadero.com>
 <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
 <4FB51577.5090100@tuxadero.com>
 <20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
 <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
 <4FB56B21.7070800@tuxadero.com>
 <20120518144759.GA1892@localhost.localdomain>
 <4FB685C9.2050607@tuxadero.com>
 <20120518190105.GB1892@localhost.localdomain>
 <4FB9BDBA.2030806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB9BDBA.2030806@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2012 at 11:59:54AM +0800, Miao Xie wrote:
> Hi Josef,
> 
> On fri, 18 May 2012 15:01:05 -0400, Josef Bacik wrote:
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 9b9b15f..492c74f 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -57,9 +57,6 @@ struct btrfs_inode {
> >  	/* used to order data wrt metadata */
> >  	struct btrfs_ordered_inode_tree ordered_tree;
> >  
> > -	/* for keeping track of orphaned inodes */
> > -	struct list_head i_orphan;
> > -
> >  	/* list of all the delalloc inodes in the FS.  There are times we need
> >  	 * to write all the delalloc pages to disk, and this list is used
> >  	 * to walk them all.
> > @@ -156,6 +153,8 @@ struct btrfs_inode {
> >  	unsigned dummy_inode:1;
> >  	unsigned in_defrag:1;
> >  	unsigned delalloc_meta_reserved:1;
> > +	unsigned has_orphan_item:1;
> > +	unsigned doing_truncate:1;
> 
> I think the problem is we should not use the different lock to protect the bit fields which
> are stored in the same machine word. Or some bit fields may be covered by the others when
> someone change those fields. Could you try to declare ->delalloc_meta_reserved and ->has_orphan_item
> as a integer?
> 

Oh freaking duh, thank you Miao, I'm an idiot.

Josef
