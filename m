Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52310 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2GBJqD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 05:46:03 -0400
Received: by eeit10 with SMTP id t10so1986071eei.19
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 02:46:02 -0700 (PDT)
Date: Mon, 2 Jul 2012 12:45:57 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs-progs: make get default report correctly
Message-ID: <20120702094557.GA2653@zambezi.lan>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1340964038-32584-2-git-send-email-liubo2009@cn.fujitsu.com>
 <20120629103643.GB1877@zambezi.lan>
 <4FF0FBE1.4000303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF0FBE1.4000303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 09:39:45AM +0800, Liu Bo wrote:
> On 06/29/2012 06:36 PM, Ilya Dryomov wrote:
> 
> > On Fri, Jun 29, 2012 at 06:00:37PM +0800, Liu Bo wrote:
> >> We have both set-default and get-default, but actually our get-default
> >> does not show which one is the default one.
> >>
> >> This patch plus the kernel side patch fix this.
> > 
> > Are you referring to the fact that get-default in Chris' btrfs-progs
> > master lists all subvolumes instead of showing the default one?  If so,
> > I fixed that problem a while ago, patch is in Hugo's integration branch.
> > 
> 
> 
> So can you please show me a link about your patch?

I'm sorry, it turns out Hugo hasn't pushed it yet.  Here is a link:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/16187/

Thanks,

		Ilya
