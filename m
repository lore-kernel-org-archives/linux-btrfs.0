Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbaCQL65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 07:58:57 -0400
Date: Mon, 17 Mar 2014 12:58:56 +0100
From: David Sterba <dsterba@suse.cz>
To: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Cleanup the btrfs_workqueue related function
 type
Message-ID: <20140317115855.GA29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <1394079657-24937-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140314143903.GE32719@twin.jikos.cz>
 <5324F370.4080303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5324F370.4080303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 16, 2014 at 12:41:17AM +0000, quwenruo@cn.fujitsu.com wrote:
> On Fri, 14 Mar 2014 15:39:03 +0100, David Sterba wrote:
> > On Thu, Mar 06, 2014 at 04:19:50AM +0000, quwenruo@cn.fujitsu.com wrote:
> >> @@ -23,11 +23,13 @@
> >>   struct btrfs_workqueue;
> >>   /* Internal use only */
> >>   struct __btrfs_workqueue;
> >> +struct btrfs_work;
> >> +typedef void (*btrfs_func_t)(struct btrfs_work *arg);
> > I don't see what's wrong with the non-typedef type, CodingStyle
> > discourages from using typedefs in general (Chapter 5).
> >
> > The name btrfs_func_t is a generic, if you really need to use a typedef
> > here, please change it to something closer to the workqueues, eg.
> > btrfs_work_func_t.
> >
> btrfs_func_t is just following the work_func_t naming style,
> for btrfs it's only used to reduce the length of prototype definition.
> 
> Since btrfs_func_t is only used in btrfs, this patch can be ignored.

Thanks for considerations.  In case of the generic workqueues interface
it makes sense to provide a shortcut to the callback definition because
it appears in many structures.
