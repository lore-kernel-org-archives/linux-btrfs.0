Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbaEPMOX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 08:14:23 -0400
Date: Fri, 16 May 2014 14:14:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
Message-ID: <20140516121421.GU6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20140515170634.GR6917@twin.jikos.cz>
 <537594D9.8010902@oracle.com>
 <53759B06.9030109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53759B06.9030109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 16, 2014 at 12:58:46PM +0800, Wang Shilong wrote:
> Hi Anand,
> 
> On 05/16/2014 12:32 PM, Anand Jain wrote:
> >
> >David,
> >
> > As mentioned, this patch will back-out the earlier patch
> >
> > 50275bacab0f62b91453fbfa29e75c2bb77bf9b6
> >
> > I am confused on what I am missing ? Any comment?
> You are right, i guess dave just missed your previous thread.:-)

Oh I did, sorry.
