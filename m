Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:43318 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbdKSVSI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 16:18:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id C098D13B2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 21:18:07 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gLd2JZ6F6mk5 for <linux-btrfs@vger.kernel.org>;
        Sun, 19 Nov 2017 21:18:07 +0000 (UTC)
Subject: Re: Unrecoverable scrub errors
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
 <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
 <CAJCQCtRKPekR+bEE0xaX02Wwz0E_N1wcUxJdc_D-C9By2qMvWw@mail.gmail.com>
 <e9428f4b-8eae-1df9-aa2e-3ac96703338a@mokrynskyi.com>
 <CAJCQCtSGXWqTPUfHB467P7rB6yg0oZPOuBCCNU0YE4yzrkejyg@mail.gmail.com>
 <8cdd4e42-8a5d-052a-b894-5cb4450a079f@mokrynskyi.com>
 <6db3931f-55d2-ffdd-9fcb-5572b842d824@mokrynskyi.com>
 <436956138.99042.1511123995796.JavaMail.zimbra@karlsbakk.net>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <5a46a523-9ce4-8d2d-c904-4637eb6f436f@mokrynskyi.com>
Date: Sun, 19 Nov 2017 23:18:06 +0200
MIME-Version: 1.0
In-Reply-To: <436956138.99042.1511123995796.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This particular partition was initially created in July 2015. I've added/removed drives a few times when migrating from older to newer hardware, but never used RAID0 or any other RAID level beyond that.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

19.11.17 22:39, Roy Sigurd Karlsbakk пише:
> I guess not using RAID-0 would be a good start…
>
> Vennlig hilsen
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> Hið góða skaltu í stein höggva, hið illa í snjó rita.
