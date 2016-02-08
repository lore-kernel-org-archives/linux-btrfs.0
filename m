Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35618 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcBHMqU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 07:46:20 -0500
Received: by mail-ob0-f172.google.com with SMTP id xk3so150395080obc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 04:46:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: radek.sprta@gmail.com
In-Reply-To: <20160122152530.GX422@carfax.org.uk>
References: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
 <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com> <20160122152530.GX422@carfax.org.uk>
From: Radek Sprta <radek.sprta@gmail.com>
Date: Mon, 8 Feb 2016 13:46:00 +0100
Message-ID: <CAM7-wL2Odr-3h3x9oODq9C=exSRs+iZQTC2P7z9Cvk_3KdQ16w@mail.gmail.com>
Subject: Re: Fwd: Unmountable fs after power outage
To: Hugo Mills <hugo@carfax.org.uk>, Radek Sprta <radek.sprta@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-01-22 16:25 GMT+01:00 Hugo Mills <hugo@carfax.org.uk>:
>    Try mounting with -orecovery. That's the main approach for dealing
> with transid failures.

Tried that, but I still get the same error.
