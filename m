Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbcEQNDC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:03:02 -0400
Date: Tue, 17 May 2016 15:02:35 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs-progs: corrupt-block: Add ability to corrupt
 free space cache file
Message-ID: <20160517130235.GN511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463456878-17550-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20160517130004.GM511@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160517130004.GM511@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 03:00:04PM +0200, David Sterba wrote:
> > @@ -1065,11 +1163,12 @@ int main(int argc, char **argv)
> >  			{ "delete", no_argument, NULL, 'd'},
> >  			{ "root", no_argument, NULL, 'r'},
> >  			{ "csum", required_argument, NULL, 'C'},
> > +			{ "space-cache-file", required_argument, NULL, 's'},
> 
> "clear-free-space-cache" is quite long but more understandable IMHO

This is not the checker, so this would be ok as "space-cache" as it's
in the context of 'corrupt-block'.
