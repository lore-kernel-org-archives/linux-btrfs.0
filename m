From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Tuning of btrfs for throughput?
Date: Mon, 30 Jan 2012 11:35:31 -0800
Message-ID: <CACyXjPxb3Ped7yvv5je_g76T+uDKKYkhC7t7MY_-GQK3WuTQ-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am interested in any feedback on tuning btrfs for throughput?

I am running on 3.2.1 and have set up btrfs across 11 7200RPM 1TB 3.5"
drives. I told btrfs to mirror metadata and stripe data.

For my current simple throughput tests I am running dd with 256kiB
blocks and 1M blocks (memory is 64Gib).

All tests are done with conv=fdatasync and then with and without oflags=direct.

I get around 800MB/s in the non DIRECTIO case, and around 430MB/s in
the DIRECTIO case (which is pretty impressive it seems to me).

However, what I would like to know is are there any tuning parameters
I can tweak to push the numbers up a bit?

I see lots of idle time (80+%) on my 16 cores (probably two by four by two).

Would I be better of with 10 drives rather than 11, or 12 rather than 11?

-- 
Regards,
Richard Sharpe
