Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46880 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdKVL5o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 06:57:44 -0500
Subject: Re: Kernel 4.14 RAID5 multi disk array on bcache not mounting
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Andy Leadbetter <andy.leadbetter@theleadbetters.com>,
        linux-btrfs@vger.kernel.org
References: <CAJUWh6odg=eAxmQk_+gvrMkqrptEpykd4EB54_tF31grELsGgQ@mail.gmail.com>
 <3527f0ed-941e-d736-c472-23ce11699cbd@bouton.name>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <e37f5dbd-da2b-17a6-f5f4-29780b2f7e23@applied-asynchrony.com>
Date: Wed, 22 Nov 2017 12:57:42 +0100
MIME-Version: 1.0
In-Reply-To: <3527f0ed-941e-d736-c472-23ce11699cbd@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/17 23:22, Lionel Bouton wrote:
> Le 21/11/2017 à 23:04, Andy Leadbetter a écrit :
>> I have a 4 disk array on top of 120GB bcache setup, arranged as follows
> [...]
>> Upgraded today to 4.14.1 from their PPA and the
> 
> 4.14 and 4.14.1 have a nasty bug affecting bcache users. See for example
> :
> https://www.reddit.com/r/linux/comments/7eh2oz/serious_regression_in_linux_414_using_bcache_can/

4.14.2 (just out as rc1) will have the fix.

-h
