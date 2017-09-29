Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44043 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdI2XHH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 19:07:07 -0400
Received: by mail-wm0-f65.google.com with SMTP id m127so1492714wmm.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 16:07:06 -0700 (PDT)
Subject: Re: Can't remove device -> I/O error
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
 <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
From: DocMAX <docmax1978@gmail.com>
Message-ID: <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
Date: Sat, 30 Sep 2017 01:06:12 +0200
MIME-Version: 1.0
In-Reply-To: <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 >> Did you removed the disk before mounting (physically or doing echo 1 
 >/sys/block/xxx/device/delete)? Which steps you performed ?

- removed drive physically

- mounted degraded mode

- btrfs dev del -> same i/o error


