Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34088 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbFYMIo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 08:08:44 -0400
Received: by iebmu5 with SMTP id mu5so52696791ieb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 05:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150625041620.GK16468@merlins.org>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<20150617174630.GM16468@merlins.org>
	<CAC8ULPb2XCniELiuJtEajf=8usGTW14xzyfZLP9kxo3-fQ01dA@mail.gmail.com>
	<20150625041620.GK16468@merlins.org>
Date: Thu, 25 Jun 2015 13:08:43 +0100
Message-ID: <CAO5K3OeQTi4U02uJu+Df-00ci+P7E4HLw3x8CH3j0Uq937tQ6w@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Vytautas D <vytdau@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Robert Munteanu <robert.munteanu@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's unfortunate. Many users, including me, started using btrfs by
converting from ext4. I hope this gets fixed.

Vytas

On Thu, Jun 25, 2015 at 5:16 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Thu, Jun 18, 2015 at 02:05:04PM +0300, Robert Munteanu wrote:
>> On Wed, Jun 17, 2015 at 8:46 PM, Marc MERLIN <marc@merlins.org> wrote:
>> > On Fri, Jun 12, 2015 at 03:19:06PM +0300, Robert Munteanu wrote:
>> >> Hi,
>> >
>> > Note to others: kernel 4.0.4
>> >
>> > Reply to you:
>> > I tried ext4 to btrfs once a year ago and it severely mangled my
>> > filesystem.
>> > I looked at it as a cool feature/hack that may have worked some time ago, but
>> > that no one really uses anymore, and that may not work right at this
>> > point.
>> >
>> > Unless you hear back from a developer interested in debugging/fixing
>> > this, I would assume that this feature is broken and dead.
>>
>> I did hear, but in case the general consensus is that this feature is
>> broken/experimental/unsafe, it would be great to mention it in the
>> wiki page.
>
> Done
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
