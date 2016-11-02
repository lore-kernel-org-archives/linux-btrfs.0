Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36166 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbcKBGbw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 02:31:52 -0400
Received: by mail-wm0-f68.google.com with SMTP id c17so1295959wmc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Nov 2016 23:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net>
From: Alex Powell <alexj.powellalt@googlemail.com>
Date: Wed, 2 Nov 2016 17:01:50 +1030
Message-ID: <CAKGv6CrpnfHhC8=tCcrH1+c+a0vLcLwz96gqoNCAxF6TxYD75g@mail.gmail.com>
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,
Taking a step back as well- there is also the possibility that you
might not need snapshots

I say this as you're a noobie- like me!
If you're a noobie, I assume you're not using it to host some massive
Oracle DB and need all these features

If you're using this for a home media server or some other small scale
project (small business) then perhaps incremental backups to another
array (preferably offsite) is what you need.
Even if the above isn't correct about you- it might be true of someone
reading this, so probably worth mentioning

Cheers

On Wed, Nov 2, 2016 at 4:33 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Ahmed Badr posted on Wed, 02 Nov 2016 02:00:55 +0200 as excerpted:
>
>> Btrfs newbie here trying to figure out how to use it properly on Ubuntu
>> 16.04 server.
>>
>> I have root formated using Btrfs, and installed Snapper [...]
>
> I see Hans answered your direct question so I'll skip that, but one
> additional hint, in case you hadn't seen it yet and your snapshot
> management helpers aren't setup to take care of this automatically
> (possibly because you're using two of them)...
>
> Btrfs tends to have scaling issues if you let the number of snapshots get
> too high.  Try to keep it under 300 snapshots per subvolume (combined
> between all tools) if at all possible, and if your use-case makes it easy
> enough, try to keep it under 100 snapshots per subvolume.  Definitely
> don't let it get into the thousands of snapshots per subvolume, or
> commands such as btrfs balance and btrfs check will take MUCH longer and
> use MANY TIMES more memory.
>
> With automated snapshot management such as snapper, just make sure it's
> thinning down the snapshots at a reasonable rate as well, and ultimately
> deleting the oldest ones.  With proper thinning, it's easily possible to
> keep to around 250-ish snapshots, even starting at ever half hour or so.
> With that, proper thinning probably means thinning down to perhaps every
> hour to every three hours after 24 hours, then to two snapshots a day
> after a couple more days and one a day after a week.  Continue thinning
> after that, until after say a quarter (13 weeks) you're only keeping one
> a week, and after six months you're only keeping quarterly snapshots --
> if you're not deleting all snapshots at six months because you switch to
> alternative media backups before that.
>
> The thing for you is that since you're using two different automated
> snapshot tools, you need to make sure the combined total still stays
> below that 300, and below 100 if your use-case can handle it, as it'll
> definitely mean more efficient processing if you need to run a balance or
> check.
>
> Second tip, btrfs quotas can make the scaling issues much worse.  If your
> use-case doesn't require them, simply turn them off (or never activate
> them in the first place) and avoid the management complexity they bring.
> A number of people have reported problems that simply disappeared when
> they turned off btrfs quotas, so being proactive and turning them off if
> you don't need them, to avoid having the issues in the first place,
> certainly can't hurt.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
