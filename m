Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38156 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdI3Kkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 06:40:31 -0400
Received: by mail-wm0-f68.google.com with SMTP id q124so978947wmb.5
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 03:40:31 -0700 (PDT)
Subject: Re: Can't remove device -> I/O error
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
 <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
 <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
 <a6b8c59a-dd64-daba-353a-b3299e977148@inwind.it>
From: DocMAX <docmax1978@gmail.com>
Message-ID: <7592946d-234c-5e34-b24c-19cac802fe39@gmail.com>
Date: Sat, 30 Sep 2017 12:40:27 +0200
MIME-Version: 1.0
In-Reply-To: <a6b8c59a-dd64-daba-353a-b3299e977148@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I removed with "echo" command and also physically.

Both quit with I/O error.



Am 30.09.2017 um 09:16 schrieb Goffredo Baroncelli:
> On 09/30/2017 01:06 AM, DocMAX wrote:
>>>> Did you removed the disk before mounting (physically or doing echo 1 >/sys/block/xxx/device/delete)? Which steps you performed ?
>> - removed drive physically
>>
>> - mounted degraded mode
>>
>> - btrfs dev del -> same i/o error
>>
> Did you switch off the machine ? If not, before mounting in degraded mode, do "echo 1 >/sys/block/xxx/device/delete". After the monting do a btrfs dev del missing
>
>
>
>

