Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:59585 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751534AbdILImy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 04:42:54 -0400
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
Date: Tue, 12 Sep 2017 11:42:52 +0300
MIME-Version: 1.0
In-Reply-To: <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/17 11:25, Timofey Titovets wrote:
> AFAIK, if while read BTRFS get Read Error in RAID1, application will
> also see that error and if application can't handle it -> you got a
> problems
>
> So Btrfs RAID1 ONLY protect data, not application (qemu in your case).
That's news to me! Why doesn't it try another copy and when does it 
correct the error then? Any idea on how to work it around at least for 
qemu? (Assemble the array from within the VM?)

--

With Best Regards,
Marat Khalili
