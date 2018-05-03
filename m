Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:52854 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751181AbeECTAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 15:00:46 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, waxhead@dirtcellar.net,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <99e79113-39ac-e67e-ff22-bfcfcdac00bc@gmail.com>
 <432bd25d-b823-9661-a408-11864df43425@inwind.it>
 <213fdc27-747b-0b14-d4a6-9f3b8c3bf0d0@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <595ed6f9-9f05-273f-a5ee-39b25c89e9bd@inwind.it>
Date: Thu, 3 May 2018 21:00:43 +0200
MIME-Version: 1.0
In-Reply-To: <213fdc27-747b-0b14-d4a6-9f3b8c3bf0d0@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2018 01:26 PM, Austin S. Hemmelgarn wrote:
>> My intention was to highlight that the parity-checksum is not related to the reliability and safety of raid5/6.
> It may not be related to the safety, but it is arguably indirectly related to the reliability, dependent on your definition of reliability.  Spending less time verifying the parity means you're spending less time in an indeterminate state of usability, which arguably does improve the reliability of the system.  However, that does still have nothing to do with the write hole.

If you start a scrub once per week, the fact that grub requires 1 hr, or 1 day doesn't impact the reliability, because in any case you have 1 week of un-scrubbed data.


BR 
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
