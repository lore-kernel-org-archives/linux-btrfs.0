Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47434 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3AOMq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 07:46:58 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so20639eaa.37
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 04:46:57 -0800 (PST)
Date: Tue, 15 Jan 2013 14:46:50 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Arvin Schnell <aschnell@suse.de>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130115124650.GA2040@zambezi.lan>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de>
 <1357681304-2978-3-git-send-email-mfasheh@suse.de>
 <20130114141814.GA7265@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130114141814.GA7265@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 03:18:14PM +0100, Arvin Schnell wrote:
> 
> Hi,
> 
> please find attached a patch to make the new libbtrfs usable from
> C++ (at least for the parts snapper will likely need).
> 
> Regards,
>   Arvin
> 
> -- 
> Arvin Schnell, <aschnell@suse.de>
> Senior Software Engineer, Research & Development
> SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
> Maxfeldstraße 5
> 90409 Nürnberg
> Germany

> diff --git a/cmds-send.c b/cmds-send.c
> index 9b47e70..c51310a 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -40,6 +40,10 @@
>  #include "send.h"
>  #include "send-utils.h"
>  
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
>  static int g_verbose = 0;
>  
>  struct btrfs_send {
> @@ -654,3 +658,7 @@ int cmd_send(int argc, char **argv)
>  {
>  	return cmd_send_start(argc, argv);
>  }
> +
> +#ifdef __cplusplus
> +}
> +#endif

Hi Arvin,

Why exactly do we need this in a non-header file?

Thanks,

		Ilya
