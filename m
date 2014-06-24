Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62766 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbaFXBs0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 21:48:26 -0400
Message-ID: <1403574192.3826.2.camel@localhost.localdomain>
Subject: Re: [PATCH 2/4] btrfs-progs: deal with invalid option combinations
 for btrfs-image
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Tue, 24 Jun 2014 09:43:12 +0800
In-Reply-To: <20140623141214.GF1553@twin.jikos.cz>
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1403142363-29482-2-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140623141214.GF1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-06-23 at 16:12 +0200, David Sterba wrote:
> On Thu, Jun 19, 2014 at 09:46:01AM +0800, Gui Hecheng wrote:
> > For btrfs-image,
> > 	dump 	may not come with option '-o'
> > 	-r	may not come with option '-c', '-s', '-w', dev_cnt != 1
> > 	-m	may not come with dev_cnt < 2
> > All of the above should be regarded as invalid combinations,
> > and the usage will show up.
> 
> The generic usage works, but is not very descriptive what really
> happened. Would be good to print a message as soon as an error is
> detectd. See below:
> 
> > @@ -2500,15 +2501,20 @@ int main(int argc, char *argv[])
> >  		}
> >  	}
> >  
> > -	if ((old_restore) && create)
> > -		print_usage();
> 
> In this case the old code makes more sense followed by the message that
> create and restore cannot be used at the same time.
> 
> > -	if (multi_devices && dev_cnt < 2)
> > -		print_usage();
> 
> Applies to both modes, eg. "not enoug devices specified for -m option".
> 
> > -	if (!multi_devices && dev_cnt != 1)
> > +	if (create) {
> > +		usage_error = old_restore;
> > +	} else {
> > +		usage_error = walk_trees || sanitize || compress_level;
> 
> Error message here if usage_error is set.
> 
> > +		if (multi_devices)
> > +			usage_error = usage_error || (dev_cnt < 2);
> > +		else
> > +			usage_error = usage_error || (dev_cnt != 1);
> 
> Could be merged with the multi_devices check above, accepts only one
> without -m option.

Yes, I'll arrange the error messages well soon. Thanks.


