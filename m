Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45916 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0Gyc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 01:54:32 -0500
Received: by mail-ob0-f175.google.com with SMTP id wn1so5975605obc.6
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 22:54:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390805294-24617-1-git-send-email-sachin.kamat@linaro.org>
References: <1390805294-24617-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 27 Jan 2014 12:24:31 +0530
Message-ID: <CAK9yfHzOxQqmzAtiTxrHnqjB2x1uvtWNqJuebHU=0=YQ=c+-kA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: Use PTR_ERR_OR_ZERO
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: clm <clm@fb.com>, jbacik <jbacik@fb.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 January 2014 12:18, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> PTR_RET is deprecated. Use PTR_ERR_OR_ZERO instead. While at it
> also include missing err.h header.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---

Please note, there is no second patch in this series. Sorry for the
confusion caused if any by the
patch title.

-- 
With warm regards,
Sachin
