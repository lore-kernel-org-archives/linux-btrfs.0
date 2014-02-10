Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:39843 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBJSyW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 13:54:22 -0500
Received: by mail-vb0-f51.google.com with SMTP id 11so4988858vbe.24
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 10:54:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F91D53.5060902@fb.com>
References: <52F9014F.6070901@fb.com>
	<20140210170606.GK6490@carfax.org.uk>
	<CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
	<52F91A4A.4080807@fb.com>
	<CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
	<52F91D53.5060902@fb.com>
Date: Mon, 10 Feb 2014 12:54:21 -0600
Message-ID: <CAE5mzvgi1TYtoZav_N0JK4k2-d6JmWMrRzg4efKAGxYrfpXJXQ@mail.gmail.com>
Subject: Re: What to do about df and btrfs fi df
From: cwillu <cwillu@cwillu.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> IMO, used should definitely include metadata, especially given that we
>> inline small files.
>>
>> I can convince myself both that this implies that we should roll it
>> into b_avail, and that we should go the other way and only report the
>> actual used number for metadata as well, so I might just plead
>> insanity here.
>
> I could be convinced to do this.  So we have
>
> total: (total disk bytes) / (raid multiplier)
> used: (total used in data block groups) +
>         (total used in metadata block groups)
> avail: total - (total used in data block groups +
>                 total metadata block groups)
>
> That seems like the simplest to code up.  Then we can argue about whether to
> use the total metadata size or just the used metadata size for b_avail.
> Seem reasonable?

I can't think of any situations where this results in tears.
