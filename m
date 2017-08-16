Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57475 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbdHPCrD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 22:47:03 -0400
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Paulo Dias <paulo.miguel.dias@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <dfb985f1-bfab-ddb9-e727-fa042619cd0b@gmx.com>
 <CADJPUQ-Rok_oWe0_0ZPDZ10vVSsM8iOKd5P=4ZSyXfq_ZU2EPw@mail.gmail.com>
 <29c3cbfa-ff62-a103-6b7e-a42ec5bc0137@gmx.com>
Message-ID: <bc8f8259-1da2-5b00-c393-e7a51c749b55@gmx.com>
Date: Wed, 16 Aug 2017 10:46:56 +0800
MIME-Version: 1.0
In-Reply-To: <29c3cbfa-ff62-a103-6b7e-a42ec5bc0137@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月16日 10:28, Qu Wenruo wrote:
> 
> OK, data is not touched.
> Single to single, so data chunks are not touched.
> And your metadata is always good, so no problem should happen during 
> balance.
Sorry, this part is wrong.

Data chunk is relocated, so I'm curious why there is no such kernel log 
warning about the csum mismatch.

Thanks,
Qu
