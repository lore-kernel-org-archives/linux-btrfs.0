Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48337 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaJCRLJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Oct 2014 13:11:09 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so2021781wgg.20
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 10:11:08 -0700 (PDT)
Date: Fri, 3 Oct 2014 10:11:03 -0700
From: Zach Brown <zab@zabbo.net>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Remove branch hints
Message-ID: <20141003171103.GB21660@lenny.home.zabbo.net>
References: <cover.1412265734.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1412265734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 02, 2014 at 06:53:49PM +0200, David Sterba wrote:
> Two patches removing some 'unlikely' branch hints where it does not make much
> sense. Sent separately from the other cleanups in case they do not seem to fit.
> 
> You can pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git remove-unlikely
> 
> David Sterba (2):
>   btrfs: remove unlikely from NULL checks
>   btrfs: remove unlikely from data-dependent branches and slow paths

Enthusiastically-Reviewed-by: Zach Brown <zab@zabbo.net>

- z
