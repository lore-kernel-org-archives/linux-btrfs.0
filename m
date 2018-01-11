Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41318 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753806AbeAKLxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 06:53:04 -0500
Received: by mail-qt0-f196.google.com with SMTP id i40so1422930qti.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 03:53:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3b9c23e7-ce32-44a3-f3d2-9da8287116ed@suse.com>
References: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv> <3b9c23e7-ce32-44a3-f3d2-9da8287116ed@suse.com>
From: "Fajar A. Nugraha" <list@fajar.net>
Date: Thu, 11 Jan 2018 18:53:03 +0700
Message-ID: <CAG1y0sfDDqP_oVntE7V_UAAa+4g5ZKF3ociYhjVtiU2CvRHaAw@mail.gmail.com>
Subject: Re: recommendations and contraindications of using btrfs for Oracle
 Database Server
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Ext-Strii-Houttemane Philippe <Philippe.Houttemane@cetim.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 11, 2018 at 6:23 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 11.01.2018 12:51, Ext-Strii-Houttemane Philippe wrote:
>> Hello,
>>
>>    We are using btrfs filesystem on local disks (RAID 1) as underlying filesystem to host our Oracle 12c datafiles.
>> This allow us to cold backup databases via snapshot in a few seconds and benefit from higher performance than over Linux filesystem formats.
>> This is the problem we meet: Oracle regularly crashes with error of this 2 types, the errors occur on different physical machines with same softwares:
>>
>> ORA-63999: data file suffered media failure
>> ORA-01114: IO error writing block to file 99 (block # 99968)
>> ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
>> ORA-27072: File I/O error
>> Linux-x86_64 Error: 17: File exists



>> Mount options: defaults,nofail,nodatacow,nobarrier,noatime
>>
>> uname -a:
>> Linux 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>


> You are using a vendor-specific kernel. It's best if you turn to them
> for support since it's very likely their code doesn't match what is in
> upstream, let alone the fact you are using an ancient kernel.


3.10 is redhat compatible kernel. They put btrfs as tech preview, and
will deprecate it after 7.4. So it's probably useless to ask redhat
for support on that.

@Philippe, you might want to try Oracle's UEK R4. At least they're
still promoting btrfs improvements in their kernel, and you might be
able to ask them in case of problems (assuming you have proper
subscription & support). However IIRC oracle only supports btrfs for
its application binary, and not for the data files (again, you should
contact oracle support to be sure).

If you simply want to use latest kernel (with latest btrfs fixes) to
see if your problem still occurs, and don't care about support, you
can try kernel-ml (http://elrepo.org/tiki/kernel-ml) or compile your
own.

-- 
Fajar
