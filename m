Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36725 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbKRMCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 07:02:12 -0500
Received: by lfs39 with SMTP id 39so24772869lfs.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 04:02:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564C0D18.6040802@cn.fujitsu.com>
References: <CA+xOVSMpsSNfBxOghUe8H2QhzLDTC8EAABwkvrE12hUOFmfDig@mail.gmail.com>
	<564BEA55.4040209@gmx.com>
	<CA+xOVSMN+_H546rx3UCQht1yYd6F9KLr1vzAfK+JVHJXUF0rOw@mail.gmail.com>
	<564C0D18.6040802@cn.fujitsu.com>
Date: Wed, 18 Nov 2015 14:02:10 +0200
Message-ID: <CA+xOVSM6AGLM7B5UGD6EisAGsS8e61dt=FNCV6f7BE8FB9JBsg@mail.gmail.com>
Subject: Re: Transaction aborted (error -17) after crash
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Wed, Nov 18, 2015 at 7:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
> Hard to say yet.
>
> Is that the only error?
>
> And did you tried btrfsck --init-extent-tree alone?
> Although IIRC --init-extent-tree implies --repair, but it seems that extent
> tree is not correctly rebuilt at least.

btrfs check --init-extent-tree --repair gives tons of messages like this:

ref mismatch on [1628438528 16384] extent item 0, found 1
adding new tree backref on start 1628438528 len 16384 parent 0 root 258
Backref 1628438528 parent 258 root 258 not found in extent tree
backpointer mismatch on [1628438528 16384]
ref mismatch on [1628454912 16384] extent item 0, found 1
adding new tree backref on start 1628454912 len 16384 parent 0 root 7
Backref 1628454912 parent 7 root 7 not found in extent tree
backpointer mismatch on [1628454912 16384]
ref mismatch on [1628471296 16384] extent item 0, found 1
adding new tree backref on start 1628471296 len 16384 parent 0 root 7
Backref 1628471296 parent 7 root 7 not found in extent tree
backpointer mismatch on [1628471296 16384]
ref mismatch on [1628487680 16384] extent item 0, found 1
adding new tree backref on start 1628487680 len 16384 parent 0 root 7
Backref 1628487680 parent 7 root 7 not found in extent tree
backpointer mismatch on [1628487680 16384]

Anyway, that's only a backup so i think it's better to rebuild it from
scratch, right?

-- 
"ויעקב הלך לדרכו..."
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
