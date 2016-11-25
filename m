Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34012 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbcKYElR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 23:41:17 -0500
Received: by mail-oi0-f47.google.com with SMTP id y198so70458775oia.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 20:40:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161125043119.GG8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it> <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it> <20161125043119.GG8685@hungrycats.org>
From: Gareth Pye <gareth@cerberos.id.au>
Date: Fri, 25 Nov 2016 15:40:36 +1100
Message-ID: <CA+WRLO_M=HkDox6acxxLtu9rhcK1cXu03d=cXNtvMxYfvhC3WA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 3:31 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> This risk mitigation measure does rely on admins taking a machine in this
> state down immediately, and also somehow knowing not to start a scrub
> while their RAM is failing...which is kind of an annoying requirement
> for the admin.

Attempting to detect if RAM is bad when scrub starts is both time
consuming and not very reliable right.
