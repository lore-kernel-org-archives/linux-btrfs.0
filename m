Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:41233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbbHUAp0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 20:45:26 -0400
Date: Fri, 21 Aug 2015 10:45:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next conflict resolution branch for btrfs
Message-ID: <20150821104524.2f759d74@canb.auug.org.au>
In-Reply-To: <20150820173918.GA10637@ret.thefacebook.com>
References: <20150820173918.GA10637@ret.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Thu, 20 Aug 2015 13:39:18 -0400 Chris Mason <clm@fb.com> wrote:
>
> There are a few conflicts for btrfs in linux-next this time.  They are
> small, but I pushed out the merge commit I'm using here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next-merge

Thanks for that.  It seems to have merged OK but maybe it conflicts
with something later in linux-next.  Unfortunately see my other email
about a build problem.  I will keep this example merge in mind for
later.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
