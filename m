Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:55094 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVO3Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 09:29:16 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so4044959lam.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 06:29:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQYhaDEic5bwd+PEcEfwOqLwAe8cT8VPZ9je+JLRP1GPw@mail.gmail.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
 <CAJCQCtQYhaDEic5bwd+PEcEfwOqLwAe8cT8VPZ9je+JLRP1GPw@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Mon, 22 Dec 2014 14:28:54 +0000
Message-ID: <CANcfdL1f6evRNutMKpt_1qjBjvHTsx-i6Dgb5uEEjX2+hR0B-A@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
To: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 12:24 AM, Chris Murphy <lists@colorremedies.com> wrote:
> smartctl -l scterc /dev/sdX

That's really good to know. My drives are desktop and this feature is
not supported; hence, I get "SCT Error Recovery Control command not
supported".

I'll definitely go for enterprise/raid class drives that support this
command in the future; they somehow seem more transparent (if I may
say) in maintaining them.
