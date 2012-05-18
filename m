Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51886 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2EROhq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 10:37:46 -0400
Received: by bkcji2 with SMTP id ji2so2408534bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 07:37:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ6utUJHYU2hziAr2v47ZPHh3F9Ei++nK8KdEy94yPimRPUtPQ@mail.gmail.com>
References: <CAJ6utUJHYU2hziAr2v47ZPHh3F9Ei++nK8KdEy94yPimRPUtPQ@mail.gmail.com>
Date: Fri, 18 May 2012 08:37:44 -0600
Message-ID: <CAE5mzvhuZ61RAeL+K+r5HyfXJ2pYO2rpTmBgzBfEqWzzJ7SMjQ@mail.gmail.com>
Subject: Re: Problem with restore of filesystem
From: cwillu <cwillu@cwillu.com>
To: Lars Bahner <bahner@onlinebackupcompany.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2012 at 6:04 AM, Lars Bahner
<bahner@onlinebackupcompany.com> wrote:
> I have sinned!
>
> I had a production filesystem without a replica - which is bonked :(

Grr...

> Running restore ( i have tried Debian's btrfs-tools; master and
> dangerdonteveruse branches version ) on kernels 3.2 and 3.3 I
> consistently get this error message, and I would like suggestions as
> to how i might proceed.

It's worth trying to mount with the latest 3.4rc; it might be able to
hobble along.
