Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54199 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2JHJub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 05:50:31 -0400
Date: Mon, 8 Oct 2012 11:50:25 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH v3 1/2] btrfs-progs: limit the max value of leafsize and
 nodesize
Message-ID: <20121008095025.GG4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349683841-27981-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349683841-27981-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please let us know what changed from v2 -> v3. The usual place for such
comments is pointed below:

On Mon, Oct 08, 2012 at 04:10:40PM +0800, Robin Dong wrote:
[changelog ...]
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: David Sterba <dave@jikos.cz>
> ---

here

>  ctree.h |    6 ++++++
>  mkfs.c  |   29 +++++++++++++++++++++++------
>  2 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 7f55229..75c1e0a 100644
[diff ...]

thanks,
david
