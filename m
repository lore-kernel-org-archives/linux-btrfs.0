Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56401 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2JIIHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 04:07:35 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so3062322wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 01:07:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d33ad0cb427c4885092e4440b5a140cb@jots.org>
References: <d33ad0cb427c4885092e4440b5a140cb@jots.org>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Tue, 9 Oct 2012 10:07:13 +0200
Message-ID: <CAGy7UtjLBuAN6HXxWsZFOAERbkqaC-h9Pb3CgLv_-R796h+0Ng@mail.gmail.com>
Subject: Re: Will RAID have issues with disks that spin down?
To: "Ken D'Ambrosio" <ken@jots.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 4, 2012 at 4:36 PM, Ken D'Ambrosio <ken@jots.org> wrote:
> Hi.  I know that several hardware RAID solutions have issues with disks that
> spin down when idle; the time to spin back up -- usually on the order of
> five seconds -- causes unhappy timeouts, etc.  I was wondering if that would
> be an issue with RAID a-la btrfs?

I run btrfs on my home server with the disks set to spin down when
idle. One of them (a Samsung 1TB) takes a whopping 10 seconds to spin
up, but btrfs has no problem with that whatsoever.

Regards,

Bart
