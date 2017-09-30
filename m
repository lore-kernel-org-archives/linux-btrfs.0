Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:45059 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdI3Ls3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 07:48:29 -0400
Received: by mail-wm0-f47.google.com with SMTP id q124so3397932wmb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 04:48:29 -0700 (PDT)
Subject: Re: Can't remove device -> I/O error
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
 <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
 <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
 <a6b8c59a-dd64-daba-353a-b3299e977148@inwind.it>
 <7592946d-234c-5e34-b24c-19cac802fe39@gmail.com>
 <a374571f-a9ac-458d-31a7-8c07787aaeb3@inwind.it>
From: DocMAX <docmax1978@gmail.com>
Message-ID: <715ff49a-5633-d9e7-75f0-c003e039626d@gmail.com>
Date: Sat, 30 Sep 2017 13:48:26 +0200
MIME-Version: 1.0
In-Reply-To: <a374571f-a9ac-458d-31a7-8c07787aaeb3@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for all your effort.
In "normal" conditions i know that the remove/delete command is working 
(i did that some times before).
But in this case it seems that i have some inconsistent data which 
prevents the operation to complete.



Am 30.09.2017 um 13:40 schrieb Goffredo Baroncelli:
> On 09/30/2017 12:40 PM, DocMAX wrote:
>> I removed with "echo" command and also physically.
>>
>> Both quit with I/O error.
> Below the step which I used to simulate (in a virtual machine) your issue:
>

