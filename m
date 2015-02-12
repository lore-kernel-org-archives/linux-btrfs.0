Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbbBLKr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 05:47:26 -0500
Date: Thu, 12 Feb 2015 18:47:15 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/1 V2] export symbol kobject_move()
Message-ID: <20150212104715.GA3503@kroah.com>
References: <1423439315-4543-1-git-send-email-anand.jain@oracle.com>
 <1423695817-8895-1-git-send-email-anand.jain@oracle.com>
 <20150212095314.GP28877@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150212095314.GP28877@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 10:53:14AM +0100, David Sterba wrote:
> Adding Greg to CC.
> 
> On Thu, Feb 12, 2015 at 07:03:37AM +0800, Anand Jain wrote:
> > drivers/cpufreq/cpufreq.c is already using this function. And now btrfs
> > needs it as well. export symbol kobject_move().
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> > v1->v2: Didn't notice there wasn't my signed-off, now added. Thanks Dave.
> > 
> >  lib/kobject.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 58751bb..e055c06 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -548,6 +548,7 @@ out:
> >  	kfree(devpath);
> >  	return error;
> >  }
> > +EXPORT_SYMBOL_GPL(kobject_move);
> 
> Looks ok to me. There's another user of this function in
> drivers/cpufreq/cpufreq.c, but apparenly not a module so the export was
> not needed.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
