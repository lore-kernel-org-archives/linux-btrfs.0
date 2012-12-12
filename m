Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44300 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab2LLSio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 13:38:44 -0500
Message-Id: <1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
From: merc1984@f-m.fm
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Encryption
Date: Wed, 12 Dec 2012 10:38:43 -0800
In-Reply-To: <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
 <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
 <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, Dec 12, 2012, at 10:31, Mitch Harder wrote:
> I run btrfs on top of LUKS encryption on my laptop.  You should be able to do the same.
>
> You could then run rsync through ssh.  However, rsync will have no knowledge of any blocks shared under subvolume snapshots.
>
> Btrfs does not yet have internal encryption.

The FAQ says specifically to NOT run BTRFS with any kind of volume
encryption, so you're asking for trouble.

And clearly encryption is not possible if you need snapshots.

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/help/overview_quotes.html

