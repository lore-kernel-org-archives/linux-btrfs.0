Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942075AbcJFPpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 11:45:04 -0400
Date: Thu, 6 Oct 2016 17:45:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Prasanth K S R <kosigiprasanth@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Prasanth K S R <prasanth.ksr@dell.com>,
        dsterba@suse.com
Subject: Re: [PATCH] Btrfs-progs: subvol_uuid_search: Return error code on
 memory allocation failure
Message-ID: <20161006154501.GJ6576@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1475672592-3963-1-git-send-email-kosigiprasanth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475672592-3963-1-git-send-email-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 05, 2016 at 06:33:12PM +0530, Prasanth K S R wrote:
> From: Prasanth K S R <prasanth.ksr@dell.com>
> 
> This commit fixes coverity defect CID 1328695.
> 
> Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
> ---
>  send-utils.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/send-utils.c b/send-utils.c
> index a85fa08..6f80b6f 100644
> --- a/send-utils.c
> +++ b/send-utils.c
> @@ -486,6 +486,11 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
>  		info->path = strdup(path);
>  	} else {
>  		info->path = malloc(PATH_MAX);
> +		if (!info->path) {
> +			fprintf(stderr, "Memory allocation failed\n");

Please use the error() helper (does not need \n terminated string).

Also, would be grat to convert subvol_uuid_search to return ERR_PTR
style value (which means to conver all callers). Now we don't see why
exactly it fails and interpret it as nonexistence of the uuid.
