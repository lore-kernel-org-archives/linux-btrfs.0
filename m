Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45099 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2IQMHm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 08:07:42 -0400
Received: by eekc1 with SMTP id c1so3384589eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 05:07:41 -0700 (PDT)
Date: Mon, 17 Sep 2012 15:07:37 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120917120737.GA1966@zambezi.lan>
References: <5051BAB8.7080200@cn.fujitsu.com>
 <20120914135418.GM17430@twin.jikos.cz>
 <5056890C.5020208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5056890C.5020208@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:21:00AM +0800, Miao Xie wrote:
> On fri, 14 Sep 2012 15:54:18 +0200, David Sterba wrote:
> > On Thu, Sep 13, 2012 at 06:51:36PM +0800, Miao Xie wrote:
> >> div_factor{_fine} has been implemented for two times, cleanup it.
> >> And I move them into a independent file named math.h because they are
> >> common math functions.
> > 
> > You removed the sanity checks:
> > 
> > -       if (factor <= 0)
> > -               return 0;
> > -       if (factor >= 100)
> > -               return num;
> 
> As inline functions, they should not contain complex checks, the caller should
> make sure the parameters are right. I think.

div_factor_fine() in volumes.c is not inline, and is called from
chunk_usage_filter() on unvalidated user input.  If you think the caller
should do those checks, you should move them to the caller as part of
your patch.

Thanks,

		Ilya
