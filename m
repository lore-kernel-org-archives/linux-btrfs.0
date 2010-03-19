From: Mark Rada <marada@uwaterloo.ca>
Subject: Balance taking a lot longer than before
Date: Thu, 18 Mar 2010 21:44:07 -0400
Message-ID: <77201DCC-CC67-4B00-8FFE-AAB17A5D18DA@mailservices.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi devs,

I've been using btrfs on my file server since 2.6.32 and after upgradin=
g to .33 I noticed that rebalancing took way longer than before.

I have a 5 disk array used for a btrfs md setup, different hard drive s=
izes, brands, and interfaces.

The last time I rebalanced I was using about 800GB of space on the 4.6T=
B array, and I started before I went to sleep and it was done when I wo=
ke up.=20

I'm in the middle of a rebalance right now, currently using 950GB, and =
it has been a full day and the rebalancing is not done yet. Is this an =
expected change? Is there any way to tell how much longer it will take?=
 Do you need to know more info about the setup?

Thanks,

=97
Mark Rada
marada@uwaterloo.ca






--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
