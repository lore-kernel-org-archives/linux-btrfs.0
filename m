Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46884 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3KMPzl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:55:41 -0500
Date: Wed, 13 Nov 2013 23:55:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make it static if function isn't called
 outside
Message-ID: <20131113155524.GB12122@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1384330779-16647-1-git-send-email-anand.jain@oracle.com>
 <20131113155030.GB18494@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131113155030.GB18494@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 13, 2013 at 04:50:30PM +0100, David Sterba wrote:
> On Wed, Nov 13, 2013 at 04:19:39PM +0800, Anand Jain wrote:
> > --- a/cmds-dedup.c
> > +++ b/cmds-dedup.c
> > @@ -31,7 +31,7 @@ static const char * const dedup_cmd_group_usage[] = {
> >  	NULL
> >  };
> >  
> > -int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
> > +static int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
> >  {
> >  	int ret = 0;
> >  	int fd;
> 
> FYI, this hunk modifies code in the the dedup patch that's floating
> above the other patches that may get merged to master eventually, so
> I've folded it into the dedup patch itself.
> 


Thanks for the efforts, Dave.

-liubo
