Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbbAIR6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 12:58:47 -0500
Date: Fri, 9 Jan 2015 18:58:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Christian Robottom Reis <kiko@async.com.br>
Cc: Fan Chengniang <fancn.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs qgroups show human readable sizes
Message-ID: <20150109175845.GG3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
 <20150109134853.GE15920@async.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150109134853.GE15920@async.com.br>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 11:48:53AM -0200, Christian Robottom Reis wrote:
> On Fri, Jan 09, 2015 at 02:47:05PM +0800, Fan Chengniang wrote:
> > make btrfs qgroups show human readable sizes, using -h option, example:
> 
> Oh! This is really nice. I wonder, would there be a sane way to show the
> actual path the qgroup is associated with as well?

Yes, it's basically what 'btrfs inspect subvolid-resolve 1234 /path'
does. This obviously works only for the 0-level qgroups.
