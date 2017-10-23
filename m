Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:47972 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdJWJ3S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 05:29:18 -0400
Received: by mail-lf0-f42.google.com with SMTP id k40so19345179lfi.4
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 02:29:18 -0700 (PDT)
Message-ID: <59EDB66B.9060209@gmail.com>
Date: Mon, 23 Oct 2017 11:29:15 +0200
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Scrub doesn't correct coruption
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
In-Reply-To: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2017 10:39 AM, Wolf wrote:
> [...]
>
> Is this and issue somewhere inside btrfs or is disk HW related problem?

Highly unlikely hardware related. According to SMART and dmsg, there's
no indication which would suggest disk failure.
