Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60708 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab2JKODf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 10:03:35 -0400
Date: Thu, 11 Oct 2012 10:03:32 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Sergei Trofimovich <slyich@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [btrfs-progs: PATCH] version.sh: fix version when built from
 tarball
Message-ID: <20121011140332.GH687@shiny>
References: <1349945028-19523-1-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1349945028-19523-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 11, 2012 at 02:43:48AM -0600, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> [from 0.20-rc1 tarball]
> 
> Before the patch:
>   $ ./btrfs --version
>   Btrfs Btrfs v0.19
> 
> After the patch:
>   $ ./btrfs --version
>   Btrfs v0.20-rc1

Thanks!

-chris
