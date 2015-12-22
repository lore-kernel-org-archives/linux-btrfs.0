Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34373 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbbLVMpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:45:10 -0500
Received: by mail-io0-f179.google.com with SMTP id e126so185425189ioa.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 04:45:10 -0800 (PST)
Subject: Re: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to
 replace recovery
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <567945A6.2000800@gmail.com>
Date: Tue, 22 Dec 2015 07:44:22 -0500
MIME-Version: 1.0
In-Reply-To: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-21 21:16, Qu Wenruo wrote:
> Current "recovery" mount option will only try to use backup root.
> However the word "recovery" is too generic and may be confusing for some
> users.
>
> Here introduce a new and more specific mount option, "backuproot" to
> replace "recovery" mount option.
> "Recovery" will be kept for compatibility reason, but will be
> deprecated.
>
> Also, since "backuproot" will only affect mount behavior and after
> open_ctree() it has nothing to do with the filesystem, so clear the flag
> after mount succeeded.
>
> This provides the basis for later unified "norecovery" mount option.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v4:
>    Newly introduced to avoid confusion with later 'norecovery' patch.
> ---
I ran my usual tests overnight on this part, and nothing broke, so you 
can add
Tested-by: Austin S. Hemmelgarn
here as well.

