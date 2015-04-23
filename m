Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35558 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966432AbbDWRhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:37:35 -0400
Received: by labbd9 with SMTP id bd9so18037064lab.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 10:37:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150423173647.GB29760@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
	<20150423115056.GA28566@gardel-login>
	<CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
	<20150423144708.GB29079@gardel-login>
	<CAK1hC9s9DQaL8-E4_R-4pr-iC0K93D+6Yf-nqqsUsNtfrr74eQ@mail.gmail.com>
	<20150423171248.GD29642@gardel-login>
	<CAK1hC9v65LCt7fu1MGYkx0Gpsb=cwcHVWDP4bcURr7WTK754iQ@mail.gmail.com>
	<CAK1hC9t_N1bTV4Xk_iXiqqAqmN5++fLQwk6UGgtEM4Kqw3PZSQ@mail.gmail.com>
	<20150423173647.GB29760@gardel-login>
Date: Thu, 23 Apr 2015 19:37:34 +0200
Message-ID: <CAK1hC9u_09e_pkAWiii-7bn5CzQC0fqGi-c+1Z7h-WFQzdhdHw@mail.gmail.com>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 7:36 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Thu, 23.04.15 19:29, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:
>
>> When in /var/lib/machines/poppy:
>>
>> root@hortensia ➤➤ machines/poppy # btrfs subvolume list .
>> ID 266 gen 98 top level 5 path rootvol
>> ID 268 gen 100 top level 5 path var
>> ID 269 gen 101 top level 5 path etc
>> ID 271 gen 72 top level 266 path var/lib/machines
>> ID 272 gen 77 top level 268 path var/tmp
>> ID 273 gen 77 top level 268 path var/lib/machines
>>
>> Anyone from the Btrfs ML to help ?
>
> Note that systemd-tmpfiles will create /var/tmp, and /var/lib/machines
> as subvolumes these days, if they are missing and on btrfs.
>

OK, I understand these new subvol

> Lennart
>
> --
> Lennart Poettering, Red Hat



-- 

google.com/+arnaudgabourygabx
