Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbdKIRK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 12:10:56 -0500
Date: Thu, 9 Nov 2017 18:09:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: add missing types header
Message-ID: <20171109170903.GS27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <dda485a3d788c47bb6849218f695db7b51822872.1509454674.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <dda485a3d788c47bb6849218f695db7b51822872.1509454674.git.baruch@tkos.co.il>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 02:57:54PM +0200, Baruch Siach wrote:
> Build with musl libc needs the sys/types.h header for the dev_t type,
> since this header is not included indirectly. This fixes the following
> build failure:
> 
> In file included from convert/source-fs.c:23:0:
> ./convert/source-fs.h:112:1: error: unknown type name ‘dev_t’
>  dev_t decode_dev(u32 dev);
>  ^~~~~
> convert/source-fs.c:31:1: error: unknown type name ‘dev_t’
>  dev_t decode_dev(u32 dev)
>  ^~~~~
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied, thanks.
