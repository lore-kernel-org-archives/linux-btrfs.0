Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966619AbaFTLZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:25:36 -0400
Date: Fri, 20 Jun 2014 13:25:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20140620112534.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de>
 <1403214567-3137-3-git-send-email-mfasheh@suse.de>
 <53A36348.4010106@fb.com>
 <20140619231626.GQ5484@wotan.suse.de>
 <53A36F85.60607@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A36F85.60607@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 04:17:25PM -0700, Josef Bacik wrote:
> >>We don't pay attention to the return value, we should probably abort the
> >>transaction if there is a problem.
> >
> >Abort or log an error and continue? I ask because technically we could
> >continue with the subvolume drop but obviously qgroup state will need to be
> >fixed via a future rescan. I guess the question is which is more 'friendly'
> >to the user.
> 
> I'd be ok with log an error and tell the user to rescan.  Thanks,

I agree.
