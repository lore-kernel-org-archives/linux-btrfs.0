Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42947 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeBWWlz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:41:55 -0500
Received: by mail-pl0-f67.google.com with SMTP id 31so5689406ple.9
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 14:41:54 -0800 (PST)
Date: Fri, 23 Feb 2018 14:41:53 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 16/27] btrfs-progs: use libbtrfsutil for read-only
 property
Message-ID: <20180223224153.GC7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <f906d40f5464b26fc9707a145254a48efac2ff50.1518720598.git.osandov@fb.com>
 <954ea177-da85-ae8f-41d0-3e7d46b69158@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <954ea177-da85-ae8f-41d0-3e7d46b69158@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 01:23:45PM +0900, Misono, Tomohiro wrote:
> 
> 
> On 2018/02/16 4:05, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  messages.h | 13 ++++++++++++
> >  props.c    | 69 +++++++++++++++++++++++---------------------------------------
> >  2 files changed, 38 insertions(+), 44 deletions(-)
> > 
> > diff --git a/messages.h b/messages.h
> > index 4999c7b9..004d5167 100644
> > --- a/messages.h
> > +++ b/messages.h
> > @@ -54,6 +54,19 @@
> >  			DO_ABORT_ON_ERROR;				\
> >  	} while (0)
> >  
> > +#define error_btrfs_util(err)						\
> > +	do {								\
> > +		const char *errno_str = strerror(errno);		\
> > +		const char *lib_str = btrfs_util_strerror(err)		\
> 
> "make D=trace" fails because ";" is missing here.

That's embarrassing, thanks!
