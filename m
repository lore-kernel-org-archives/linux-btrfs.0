Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:57044 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbdICLhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 07:37:36 -0400
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>
Subject: Re: joining to contribute
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Anthony Riley <anth1y@gmail.com>, linux-btrfs@vger.kernel.org
References: <CANM+MUmnKX0UJk-SN9t=aBz7Xfq6Dfn73AhZBO5EBpdSh+HVtw@mail.gmail.com>
 <07225e42-1ffe-0289-27a1-811cd6e579a5@gmx.com>
 <20170901091015.GE30990@carfax.org.uk>
Message-ID: <cfda77b9-e49f-28dd-72d1-b70dd6183201@siedziba.pl>
Date: Sun, 3 Sep 2017 13:35:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170901091015.GE30990@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
>
>    Alongside this, there's also a requirement for being able to do
> round-trip send/receive while preserving the ability to do incremental
> sends. This is likely to be related to the above bug-fix. I did a
> complete write-up of what's happening, and what needs to happen, here:
>
> http://www.spinics.net/lists/linux-btrfs/msg44089.html

I missed that discussion, but I proposed a different solution in a similar thread about send/receive (https://www.spinics.net/lists/linux-btrfs/msg60694.html)

I think it's not very useful that received_uuid encodes where the subvolume comes from. All that send / receive should care about, is that the contents of source(s) used for incremental send match the contents of subvolumes on the receive side. Let's call it, for example, "contents_uuid". The rules would be simple: operations that preserve contents preserve contents_uuid ; operations that change contents change contents_uuid. For simplicity and performance reasons, in order to not need tracking of changes, we could allow for some false positives, where contents_uuid changed when data did not. A simpler to implement set of rules could look like this:

- rw subvolumes have no contents_uuid
- changing rw subvolume to ro assigns a random contents_uuid
- ro snapshot of rw subvolume gets a random contents_uuid
- ro snapshot of ro subvolume preserves contents_uuid
- send/receive preserves contents_uuid (after successful receive)

And then the rule for send / receive would be:
- send transmits contents_uuid of subvolumes used as clone sources, which are matched to subvolumes having identical contents_uuid on the receive side.

Does it make sense? Did I miss something? I haven't received any feedback last time, which is why I bring it up again for discussion.
