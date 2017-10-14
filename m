Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33832 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753666AbdJNQTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:19:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e3P9r-0005p5-Eq
        for linux-btrfs@vger.kernel.org; Sat, 14 Oct 2017 18:19:27 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH RESEND] btrfs-progs: allow "no" to disable compression for
 convenience
Date: Sat, 14 Oct 2017 18:19:14 +0200
Message-ID: <ortddp$skc$1@blaine.gmane.org>
References: <87po9p7uu9.wl-satoru.takeuchi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87po9p7uu9.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 14-10-17 om 14:54 schreef Satoru Takeuchi:
> It's messy to use "" to disable compression. Introduce the new value "no"
> which can also be used for this purpose.

Wouldn't 'none' be a better fit?

regards,

Koen

