Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36188 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3LTXbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 18:31:45 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so1398147bkz.39
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 15:31:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan.2013.12.20.23.19.56@googlemail.com>
References: <1386963698-17766-1-git-send-email-fdmanana@gmail.com>
	<1387552666-10969-1-git-send-email-fdmanana@gmail.com>
	<pan.2013.12.20.23.19.56@googlemail.com>
Date: Fri, 20 Dec 2013 23:31:44 +0000
Message-ID: <CAL3q7H6GPTJVFEj3SCtoPgOE_qQHs8Zik40HGsxDAY4b6yf9FQ@mail.gmail.com>
Subject: Re: [PATCH v3] Btrfs: fix tree mod logging
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 20, 2013 at 11:19 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Fri, 20 Dec 2013 15:17:46 +0000, Filipe David Borba Manana wrote:
>
> [..patch..]
>
> I applied this to 3.12.6 and was rewarded with:
>
> *fs/btrfs/ctree.c: In function 'tree_mod_log_set_node_key':
> *fs/btrfs/ctree.c:924:2: error: implicit declaration of function
> '__tree_mod_log_insert_key' [-Werror=implicit-function-declaration]
> *  ret = __tree_mod_log_insert_key(fs_info, eb, slot,
> *  ^
> *cc1: some warnings being treated as errors
> *scripts/Makefile.build:308: recipe for target 'fs/btrfs/ctree.o' failed
>
> Said function prototype is nowhere to be found, only the regular non-
> scoped function. Did you just miss this call? Changing the call to the
> remaining tree_mod_log_insert_key() looks like what was intended and
> compiles, but I wanted to check before I burn the house down. :)

Did you apply first the patch titled "Btrfs: return immediately if
tree log mod is not necessary" ?
It depends on that one, and both are targeted against btrfs-next
repository from Josef. Didn't try 3.12.* at all.

Thanks


>
> -h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
