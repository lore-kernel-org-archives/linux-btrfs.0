Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:35438 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752916AbdKGMwC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 07:52:02 -0500
Date: Tue, 7 Nov 2017 15:51:39 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Chris Murphy <lists@colorremedies.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Should cp default to reflink?
Message-ID: <20171107155139.63acb49c@job>
In-Reply-To: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
References: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Nov 2017 15:37:21 -0700
Chris Murphy wrote:
> Seems to me any request to duplicate should be optimized by default
> with an auto reflink when possible, and require an explicit option to
> inhibit.

"cp --reflink=auto" by default might create unexpected behaviour of
slower balance on a filesystem with a lot of reflinks. Especially if
the filesystem already has many shapshots.
