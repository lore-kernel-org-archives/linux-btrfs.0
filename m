Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36059 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbLVMap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:30:45 -0500
Received: by mail-vk0-f47.google.com with SMTP id f2so78247117vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 04:30:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Tue, 22 Dec 2015 13:30:44 +0100
Message-ID: <CAHji153JzZu0BW80fJo38GwEesAGWbwWcLhrianwXqbvTFjJaA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to
 replace recovery
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 22, 2015 at 3:16 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Current "recovery" mount option will only try to use backup root.
> However the word "recovery" is too generic and may be confusing for some
> users.
>
> Here introduce a new and more specific mount option, "backuproot" to
> replace "recovery" mount option.
> "Recovery" will be kept for compatibility reason, but will be
> deprecated.

I agree that this makes much more sense from a user's perspective, so +1.

But why not go all the way: try backuproot automatically when the
initial mount fails,
log the fallback and simply deprecate/ignore the option?

Either this works - in which case there is no need to involve a human,
which may not
even exist - or it does not. If it does not, things are hosed anyway
and we can fail
properly.

Any reasons not to do this?

-h
