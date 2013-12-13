Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:45648 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3LMWJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 17:09:29 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 13 Dec 2013 15:09:29 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id DFB083E40040
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 15:09:27 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBDM9RsV8126950
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 23:09:27 +0100
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBDM9Rhb010988
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 15:09:27 -0700
Subject: Re: [PATCH 0/7] Patches to support subpagesize blocksize
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <52AB5470.3090108@fb.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
	 <52AB5470.3090108@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Dec 2013 16:09:26 -0600
Message-ID: <1386972566.4241.203.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2013-12-13 at 13:39 -0500, Josef Bacik wrote:
> On 12/11/2013 06:38 PM, Chandra Seetharaman wrote:
> > In btrfs, blocksize, the basic IO size of the filesystem, has been
> > more than PAGE_SIZE.
> >
> > But, some 64 bit architures, like PPC64 and ARM64 have the default
> > PAGE_SIZE as 64K, which means the filesystems handled in these
> > architectures are with a blocksize of 64K.
> >
> > This works fine as long as you create and use the filesystems within
> > these systems.
> >
> > In other words, one cannot create a filesystem in some other architecture
> > and use that filesystem in PPC64 or ARM64, and vice versa.,
> >
> > Another restriction is that we cannot use ext? filesystems in these
> > architectures as btrfs filesystems, since ext? filesystems have a blocksize
> > of 4K.
> >
> > Sometime last year, Wade Cline posted a patch(http://lwn.net/Articles/529682/).
> > I started testing it, and found many locking/race issues. So, I changed the
> > logic and created an extent_buffer_head that holds an array of extent buffers that
> > belong to a page.
> >
> > There are few wrinkles in this patchset, like some xfstests are failing, which
> > could be due to me doing something incorrectly w.r.t how the blocksize and
> > PAGE_SIZE are used in these patched.
> >
> > Would like to get some feedback, review comments.
> >
> 
> Ok so the more we talked about it on IRC and talking with Chris I think 
> we have a way forward here.
> 
> 1) Add an extent_buffer_head that embeds an extent_buffer, and in the 
> extent_buffer_head track the state of the whole page.  So this is where 
> we have a linked list of all the extent_buffers on the page, we can keep 
> track of the number of extent_buffers that are dirty/not so we can be 
> sure to set the page state and everything right.

Let me see if I understand you correctly:

In my patch I have,
-----------
extent_buffer {
        // buffer specific data
}; 

extent_buffer_head {
        // page wide data
        extent_buffer *extent_buf[];
};
--------------
You are suggesting to make it
------------
extent_buffer {
        // buffer specific data
	extent_buffer *ebuf_next; 
}; 

extent_buffer_head {
        // page wide data
        extent_buffer ebuf_first;
        extent_buffer *ebuf_next;
};
-----------
correct ? If yes, then, IMO, the code might look more convoluted as we
have to take care of two different situations ? isn't it ? 

> 
> 2) Set page->private to the first extent_buffer like we currently do.  
> Then we just have checks in the endio stuff to see if the eb we found is 
> the one for our currently range (ie bv_offset == 0) and if not do a 
> linear search through the extent_buffers on the extent_buffer_head part 
> to get the right one.
> 
> We have to do this because we need to be able to track IO for each of 
> the extent_buffer's independently of each other in case a page spans a 
> block_group.
> 
> Hopefully that makes sense, this way you don't have to futz with any of 
> my crazier long term goals of no longer using pagecache or any of that 
> mess.  Thanks,

Yeah, that would be good :)
> 
> Josef
> 


