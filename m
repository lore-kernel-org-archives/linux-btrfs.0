Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934255AbcIAVdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 17:33:43 -0400
Date: Thu, 1 Sep 2016 19:14:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfstune settings
Message-ID: <20160901171411.GU16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fac36170-075c-db45-5aff-afa55bcd9e34@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fac36170-075c-db45-5aff-afa55bcd9e34@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sun, Aug 28, 2016 at 05:42:39AM +0200, Oliver Freyermuth wrote:
> I hope this is the correct place to ask, the wiki and manpages did not
> help me on these questions. 
> 
> BTRFS has gained extended inode refs, skinny metadata and no-holes
> quite a while ago and these are now the defaults for new mkfs.btrfs.
> btrfstune can activate those features. 
> 
> However, I miss two things: 
> - How do I see on an existing FS which of these features are on? 
>   btrfstune (it seems) can only "set", but not "get" the feature flags. 
> - Is it worthwhile / recommended / safe to activate those on existing FS? 
>   Are there any steps (e.g. balancing metadata with -musage=0, I'd
>   guess) needed to make them become active afterwards? 
> 
> If there is any documentation on this and I missed it, please RTFM me. 

all your questions should be now answered and documentation cross
referenced among the relevant manual pages (will be synced to wiki at
release time:

https://github.com/kdave/btrfs-progs/blob/devel/Documentation/mkfs.btrfs.asciidoc
https://github.com/kdave/btrfs-progs/blob/devel/Documentation/btrfstune.asciidoc
https://github.com/kdave/btrfs-progs/blob/devel/Documentation/btrfs-man5.asciidoc

see sections 'FILESYSTEM FEATURES'.
