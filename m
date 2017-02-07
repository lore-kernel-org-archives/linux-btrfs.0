Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36001 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753909AbdBGUA2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:00:28 -0500
Received: by mail-it0-f54.google.com with SMTP id c7so85048523itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 11:59:46 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id n67sm117447ith.0.2017.02.07.11.59.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2017 11:59:45 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <4e91cc08-19a4-5433-c1d3-60918906b022@gmail.com>
 <20170207203913.02ffd712@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7b64beca-077c-444d-50e9-c5e616a1a3d6@gmail.com>
Date: Tue, 7 Feb 2017 14:59:41 -0500
MIME-Version: 1.0
In-Reply-To: <20170207203913.02ffd712@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 14:39, Kai Krakow wrote:
> Am Tue, 7 Feb 2017 10:06:34 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> 4. Try using in-line compression.  This can actually significantly
>> improve performance, especially if you have slow storage devices and
>> a really nice CPU.
>
> Just a side note: With nodatacow there'll be no compression, I think.
> At least for files with "chattr +C" there'll be no compression. I thus
> think "nodatacow" has the same effect.
You're absolutely right, thanks for mentioning this, I completely forgot 
to point it out myself.

