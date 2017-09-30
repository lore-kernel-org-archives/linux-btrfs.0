Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:33802 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750847AbdI3HQv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 03:16:51 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can't remove device -> I/O error
To: DocMAX <docmax1978@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
 <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
 <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <a6b8c59a-dd64-daba-353a-b3299e977148@inwind.it>
Date: Sat, 30 Sep 2017 09:16:47 +0200
MIME-Version: 1.0
In-Reply-To: <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2017 01:06 AM, DocMAX wrote:
>>> Did you removed the disk before mounting (physically or doing echo 1 >/sys/block/xxx/device/delete)? Which steps you performed ?
> 
> - removed drive physically
> 
> - mounted degraded mode
> 
> - btrfs dev del -> same i/o error
> 

Did you switch off the machine ? If not, before mounting in degraded mode, do "echo 1 >/sys/block/xxx/device/delete". After the monting do a btrfs dev del missing



> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
