Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbbJHOgb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 10:36:31 -0400
Date: Thu, 8 Oct 2015 16:35:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup iterating over prop_handlers array
Message-ID: <20151008143524.GY7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444304974-30423-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444304974-30423-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 08, 2015 at 08:49:34PM +0900, Byongho Lee wrote:
> This patch eliminates the last item of prop_handlers array which is used
> to check end of array and instead uses ARRAY_SIZE macro.
> Though this is a very tiny optimization, using ARRAY_SIZE macro is a
> good practice to iterate array.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
