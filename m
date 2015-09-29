Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964866AbbI2Md3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 08:33:29 -0400
Date: Tue, 29 Sep 2015 14:32:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unneeded NULL initializer for struct
 fs_path
Message-ID: <20150929123229.GZ11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150926120519.GA1629@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150926120519.GA1629@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2015 at 12:05:19PM +0000, Alexandru Moise wrote:
> fs_path_alloc() either returns an alloc'ed struct fs_path
> or NULL, no need to initialize the pointer to NULL.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index aa72bfd..0019c90 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2230,7 +2230,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
>  			struct fs_path *dest)
>  {
>  	int ret = 0;
> -	struct fs_path *name = NULL;
> +	struct fs_path *name;

I'd rather see all such instances fixed in one patch. Quick grep
revealed a few more. OTOH this kind of extra initialization is harmless
and sometimes help readability, it's clear that he value is zeroed.
