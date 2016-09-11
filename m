Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34531 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbcIKTNa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 15:13:30 -0400
Received: from merkaba.localnet (ppp-93-104-51-236.dynamic.mnet-online.de [93.104.51.236])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id C400C703
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 21:13:28 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Small fs
Date: Sun, 11 Sep 2016 21:13:28 +0200
Message-ID: <14309857.N6fGUh6qoJ@merkaba>
In-Reply-To: <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com> <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 16:44:23 CEST schrieb Duncan:
> * Metadata, and thus mixed-bg, defaults to DUP mode on a single-device 
> filesystem (except on ssd where I actually still use it myself, and 
> recommend it except for ssds that do firmware dedupe).  In mixed-mode 
> this means two copies of data as well, which halves the usable space.
> 
> IOW, when using mixed-mode, which is recommended under a gig, and dup 
> replication which is then the single-device default, effective usable 
> space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)

I don´t get this part. That is just *metadata* being duplicated, not the 
actual *data* inside the files. Or am I missing something here?

-- 
Martin
