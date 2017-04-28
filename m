Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:38804 "EHLO
        mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1422791AbdD1Ksh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 06:48:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 29533CD20
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 10:48:36 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6SNqLkpF7mFj for <linux-btrfs@vger.kernel.org>;
        Fri, 28 Apr 2017 10:48:35 +0000 (UTC)
Subject: Re: [PATCH 1/2 v2] btrfs-progs: fix btrfs send & receive with -e flag
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        Christian Brauner <christian.brauner@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, dsterba@suse.cz,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9hJSKnHrXPr2EvEktjHf-=OxJkhzzZbeFfB6OUYSdyJQ@mail.gmail.com>
 <20170428095530.yw74untb34oawlm2@mailbox.org>
 <CAKuJGC88jCxHBz6eTNK-F-fsuBzw4jRsDucEYqgPRKrgR8TWWA@mail.gmail.com>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <df7120cc-82a9-a90d-8832-e1767ba65d69@mokrynskyi.com>
Date: Fri, 28 Apr 2017 13:47:10 +0300
MIME-Version: 1.0
In-Reply-To: <CAKuJGC88jCxHBz6eTNK-F-fsuBzw4jRsDucEYqgPRKrgR8TWWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Sorry for confusion, I've checked once again and the same issue happens in all cases.

I didn't notice this because my regular backups are done automatically in cron task + snapshots look fine despite the error, so I incorrectly assumed an error didn't happen there, but it actually did.

I've clarified this in last comment on bugzilla.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8EF5261249

28.04.17 13:03, Lakshmipathi.G пише:
> I can take a look. What I'm wondering about is why it fails only in the HDD
> to SSD case. If -ENODATA is returned with this patch it should mean that there
> was no header data. So is the user sure that this doesn't indicate a valid
> error?
>
> Christian

