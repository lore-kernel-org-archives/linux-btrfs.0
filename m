Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbAOMFs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 07:05:48 -0500
Date: Thu, 15 Jan 2015 13:05:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Fan Chengniang <fancn.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
Message-ID: <20150115120546.GD3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
 <20150114154633.GU3685@twin.jikos.cz>
 <54B71171.60809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54B71171.60809@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2015 at 09:01:37AM +0800, Qu Wenruo wrote:
> > On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
> >> make btrfs qgroups show human readable sizes
> >> using --human-readable option, example:
> > That's too long to type
> It's completely OK to make the option shorter and make it consistent 
> with other parts,
> (BTW, fi df uses -h, no long option, why not keey consistent with it?)

I'm for adding the --human-readable variants where applicable.

> but IMHO, isn't the bash-completion script a better solution for all the 
> btrfs subcommands and options length?
> 
> Complicated commands like git have a quite good bash-completion script, 
> and with it
> option length is never a problem (except some case in git config, where 
> some options can't be completed).

A shell completion would be great of course, it's in the project ideas.
There's a starting point http://www.spinics.net/lists/linux-btrfs/msg15899.html .
