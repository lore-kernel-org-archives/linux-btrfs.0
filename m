Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:42145 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3HaKjz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 06:39:55 -0400
In-Reply-To: <708D6B3A-EF66-4978-A856-7D01B2687083@colorremedies.com>
References: <201308262335.25871.russell@coker.com.au> <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com> <5FA1D778-230D-4EB5-B7C9-537ABFFC9EAA@colorremedies.com> <708D6B3A-EF66-4978-A856-7D01B2687083@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: snapshot space available
From: Russell Coker <russell@coker.com.au>
Date: Sat, 31 Aug 2013 19:04:48 +1000
To: Chris Murphy <lists@colorremedies.com>,
        Clemens Eisserer <linuxhippy@gmail.com>
CC: linux-btrfs@vger.kernel.org
Message-ID: <61a5f306-c063-4428-9842-b10de392599f@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How would I determine when this situation is approaching?  On all important systems I have cron jobs and nagios checks to determine via df when thw file system is about to run out of space. How do I do the same for this condition? 

Chris Murphy <lists@colorremedies.com> wrote:
>
>On Aug 26, 2013, at 9:27 AM, Chris Murphy <lists@colorremedies.com>
>wrote:
>
>> I haven't tried doing a partial balance, deleting the extra device,
>then finishing the balance.
>
>Btrfs FAQ suggests a partial balance for this situation. So it's worth
>a try before adding a device.
>
>https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
>
>
>Chris Murphy

-- 
Sent from my Samsung Galaxy Note 2 with K-9 Mail.
