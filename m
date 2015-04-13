Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbbDMQ6X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 12:58:23 -0400
Date: Mon, 13 Apr 2015 18:58:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Mason <clm@fb.com>, stable <stable@vger.kernel.org>,
        Btrfs <linux-btrfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please add 9c4f61f01d269815bb7c37be3ede59c5587747c6 to stable
Message-ID: <20150413165818.GC32634@kroah.com>
References: <1427984267.10670.0@mail.thefacebook.com>
 <20150413192838.3d5a0a69@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150413192838.3d5a0a69@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2015 at 07:28:38PM +0500, Roman Mamedov wrote:
> On Thu, 2 Apr 2015 10:17:47 -0400
> Chris Mason <clm@fb.com> wrote:
> 
> > Hi stable friends,
> > 
> > Can you please backport this one to 3.19.y.  It fixes a bug introduced 
> > by:
> > 
> > 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable 
> > 3.14+
> > 
> > The symptoms of the bug are deadlocks during log reply after a crash.  
> > The patch wasn't intentionally fixing the deadlock, which is why we 
> > missed it when tagging fixes.
> 
> Unfortunately still not fixed (no btrfs-related changes) in 3.14.38 and
> 3.18.11 released today.

I have a few hundred stable backports left to sort through, don't worry,
this is still in the queue, it's not lost.

greg k-h
