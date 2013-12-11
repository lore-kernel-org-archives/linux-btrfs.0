Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61808 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKNTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 08:19:30 -0500
Received: by mail-ve0-f171.google.com with SMTP id pa12so5999864veb.30
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 05:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
Date: Wed, 11 Dec 2013 15:19:29 +0200
Message-ID: <CAK5rZE5oxr381MhwxdgwJs7HHJC2-_Du+N+FzZUAT2vVynuGcw@mail.gmail.com>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> That's actually the reason btrfs defaults to SINGLE metadata mode on
> single-device SSD-backed filesystems, as well.
>
> But as Imran points out, SSDs aren't all there is.  There's still
> spinning rust around.
>
> And defaults aside, even on SSDs it should be /possible/ to specify data-
> dup mode, because there's enough different SSD variants and enough
> different use-cases, that it's surely going to be useful some-of-the-time
> to someone. =:^)

We didn't start with SSDs but the thread heads to there. Well ok then.

Since hard drives with more complex firmwares, hybrids, and so..
are becoming available. Eventually they will share common problems with
SSDs.

To make story short lets say "Eventually we all will have block address
devices, without any sensible physically bound addresses."

Without physically bound addresses, any duplicate written to device, MAY
end up in the same unreliable portion of the device. Note it "MAY". However
the devices are so large that, this probability is very low. The paranoid who
wants to make this lower may simply increase the number of duplicates.

On the other hand people who work with multiple physical devices
may want to decrease number of duplicates. (Probably to single copy)

Hence, there is definetely use case for tunable duplicates both
data and metadata.

Now, there is one open issue:
In its current form "-d dup" interferes with "-M". Is it constraint of design?
Or an arbitrary/temporary constraint. What will be the situation if there
is tunable duplicates?

And more:
Is "-M" good for everyday usage on large fs for efficient packing?
What's the penalty? Can it be curable? If so, why not make it default?

Imran
