Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:42492 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaHDKtB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 06:49:01 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so7556815wes.37
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 03:48:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140804103929.GB31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk> <CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
 <20140804103929.GB31950@carfax.org.uk>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 11:48:17 +0100
Message-ID: <CAFChkqsQW0tKKF0qDjVcJHYykH=e7GV9NbXOF8rvQfQA=Z9YBw@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Hugo Mills <hugo@carfax.org.uk>, Peter Waller <peter@scraperwiki.com>,
        Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 August 2014 11:39, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >  * btrfs fi df
>> >     - look at metadata used vs total. If these are close to zero (on
>> >       3.15+) or close to 512 MiB (on <3.15), then you are in danger of
>> >       ENOSPC.
>>
>> Hmm. It's unfortunate that this could indicate an amount of space
>> which is free when it actually isn't.
>
>    That's why the 512 MiB block reserve was split out of metadata --
> so that you don't look at metadata and say "oh, I've got half a gig
> free, that's OK".

I don't quite follow this. Is it a recent development I missed? When
was it "split out"? More recently than the software I'm using?
Otherwise I'm having difficulty parsing this.
