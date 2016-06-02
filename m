Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34568 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbcFBQvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 12:51:18 -0400
Received: by mail-wm0-f66.google.com with SMTP id n184so16807099wmn.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 09:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSH6kBxEsvMBvaLmacm3Jgxpc7hrbAbGLB-qU-4wsehZQ@mail.gmail.com>
References: <CAC-H7HkWiTD5HYXoTuqW4rEhYSXr9xnp1xk6aZ51F_yhQ--CYw@mail.gmail.com>
 <CAJCQCtSH6kBxEsvMBvaLmacm3Jgxpc7hrbAbGLB-qU-4wsehZQ@mail.gmail.com>
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
Date: Thu, 2 Jun 2016 18:50:56 +0200
Message-ID: <CAC-H7HnwzRVBKXY7mCzUGn651HTj4UX2u834DdCKA38q_kO1Dw@mail.gmail.com>
Subject: Re: [BUG] receive not seeing file that exists
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2016 at 6:35 PM, Chris Murphy <lists@colorremedies.com> wrote:
> kernel and btrfs-profs versions?

kernel:
    send:    4.5.5
    receive: 4.5.4
btrfs-progs (both): 4.5.3

--
Benedikt
