Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3GJPvt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 11:51:49 -0400
Date: Wed, 10 Jul 2013 17:51:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        zab@redhat.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
Message-ID: <20130710155146.GC25386@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130709202443.GJ18717@lenny.home.zabbo.net>
 <1373466615-30013-1-git-send-email-dsterba@suse.cz>
 <F21C2CD4-347F-469F-99A8-BE41D0B530A2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <F21C2CD4-347F-469F-99A8-BE41D0B530A2@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 11:31:17PM +0800, Wang Shilong wrote:
> Hello David,
> 
> > From: Zach Brown <zab@redhat.com>
> > 
> duplicate information.

git-send-email tricked me, the line is not present in thre tree

> 
> > From: Zach Brown <zab@redhat.com>
> > 
> > We don't need callers to manage string storage for each pretty_sizes()
> > call.  We can use a macro to have per-thread and per-call static storage
> > so that pretty_sizes() can be used as many times as needed in printf()
> > arguments without requiring a bunch of supporting variables.
> > 
> > This lets us have a natural interface at the cost of requiring __thread
> > and TLS from gcc and a small amount of static storage.  This seems
> > better than the current code or doing something with illegible format
> > specifier macros.
> > 
> > Signed-off-by: Zach Brown <zab@redhat.com>
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> 
> OK.  please add my tag: Acked-by: Wang Shilong <wangs.fnst@cn.fujitsu.com>
>  (I have given my tag in the previous thread to Zach and cc to you!)
> 
> Zach gives a better solution,but i at least report and try for it. Isn't it?

Oh sorry, I'll add the tag of course, I was so excited with zach's patch
and missed it.

david
