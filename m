Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678Ab3IBQ77 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 12:59:59 -0400
Date: Mon, 2 Sep 2013 18:59:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: return btrfs error code for dev excl ops err
Message-ID: <20130902165957.GF23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
 <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
 <20130820183405.GH3990@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130820183405.GH3990@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 20, 2013 at 02:34:05PM -0400, Josef Bacik wrote:
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -505,8 +505,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
> >  		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
> >  			return "unable to remove the only writeable device";
> >  		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
> > -			return "add/delete/balance/replace/resize operation "\
> > -				"in progress";
> > +			return "add/delete/balance/replace/resize operation in progress";
> >  		default:
> >  			return NULL;
> 
> This is an unnecessary change.  Thanks,

Though having the whole message on one line makes errors greppable.

david
