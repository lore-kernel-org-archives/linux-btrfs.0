Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35301 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756356AbcH3RnG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 13:43:06 -0400
Received: by mail-lf0-f67.google.com with SMTP id e7so30035lfe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 10:43:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160830144050.GH16983@twin.jikos.cz>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com> <20160830144050.GH16983@twin.jikos.cz>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Tue, 30 Aug 2016 19:42:43 +0200
Message-ID: <CAJF-kYnJk9nBvjSFY-hjTd-c8WseKs+C1r-nQW+Hci-GF2ugGw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Fuzzer test fix
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> And special notes for the BUG_ON fix:
>> The fix just fixes a small corner, while tons of BUG_ON()/abort() are
>> still here and there.
>> We need quite a lot of boring work to handle them later.
>
> Yeah yeah, that's been neglected for a very long time. The kernel has
> the abort_transaction infrastructure, the userspace hasn't been updated
> in the same way. Long way to go, but every removed bug_on counts.

I've been holding back more images that reach abort() as their coming
is pretty clear and actually don't need any fuzzing: Every code path
that eventually leads to abort() will get executed sooner or later. As
of now, there are 50 unique code paths that reach abort(). Somebody
has to bite the bullet and add some error paths :-)
