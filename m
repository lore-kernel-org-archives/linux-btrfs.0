Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58786 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750747Ab3GXCCP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 22:02:15 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49534 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V1oP8-002ysh-Cq
	for linux-btrfs@vger.kernel.org; Tue, 23 Jul 2013 20:02:14 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Q: Why subvolumes?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130724012737.GB30875@localhost.localdomain>
Date: Tue, 23 Jul 2013 20:02:13 -0600
Message-Id: <8906EA5F-36B7-48FE-866B-C85152F5128B@colorremedies.com>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com> <20130723150620.GG20517@carfax.org.uk> <51EEC1BD.9030001@gmail.com> <20130723193013.GI20517@carfax.org.uk> <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com> <79612879-8561-4924-B996-570B8594237F@colorremedies.com> <CA+V+5QoSFZOc_nekBUQQSQo+wn5mNaqJNDuq=kwU23a01Nn1Kw@mail.gmail.com> <20130724012737.GB30875@localhost.localdomain>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 23, 2013, at 7:27 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> 
> Subvolumes are described as directories simply to make it easier to understand.
> Directories do not change the heirarchy within the file system itself, they are
> simply items in the btree like anything else, they are not special at all.
> Subvolumes are _represented_ as directories, but really the directories are just
> links to subvolumes.  Subvolumes are a completely separate b-tree, it has it's
> own locking, it's own inode numbering and everything.  And this isn't inode
> numbering for the sake of inode numbering, our inode numbers are picked by
> simply being the next largest objectid we can add to our tree.  Since a
> subvolume is it's own tree it's inode numbers start over at the begining.
> 
> So it's not that we can just fork off a directory and snapshot there, because
> it's not a tree, it's just an item.  A subvolume is its own tree, which can be
> snapshotted and locked independantly from the other subvolumes.  Thanks,


I like this, it's useful. Could it be integrated into the Wiki?


Chris Murphy