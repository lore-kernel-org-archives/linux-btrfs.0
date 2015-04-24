Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34260 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbbDXGat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 02:30:49 -0400
Received: by lbcga7 with SMTP id ga7so29364923lbc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 23:30:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9uWmrO48XZjw53LM-pNhkiM-zWYtfCMwdVq51-q=qQ0LQ@mail.gmail.com>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
	<20150423115056.GA28566@gardel-login>
	<CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
	<20150423144708.GB29079@gardel-login>
	<CAK1hC9s9DQaL8-E4_R-4pr-iC0K93D+6Yf-nqqsUsNtfrr74eQ@mail.gmail.com>
	<20150423171248.GD29642@gardel-login>
	<CAK1hC9v65LCt7fu1MGYkx0Gpsb=cwcHVWDP4bcURr7WTK754iQ@mail.gmail.com>
	<CAK1hC9t_N1bTV4Xk_iXiqqAqmN5++fLQwk6UGgtEM4Kqw3PZSQ@mail.gmail.com>
	<20150423173647.GB29760@gardel-login>
	<CAK1hC9u_09e_pkAWiii-7bn5CzQC0fqGi-c+1Z7h-WFQzdhdHw@mail.gmail.com>
	<CAK1hC9uGYp7UhgtgaRhD=B41XOssEuQdc1wtEPTju=O8chA=Mw@mail.gmail.com>
	<CAK1hC9uWmrO48XZjw53LM-pNhkiM-zWYtfCMwdVq51-q=qQ0LQ@mail.gmail.com>
Date: Fri, 24 Apr 2015 08:30:47 +0200
Message-ID: <CAK1hC9sU=TA6gFkV1M493LeVkC_uCSXW6jnfynL4+W=6oi_-rg@mail.gmail.com>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 8:16 AM, arnaud gaboury
<arnaud.gaboury@gmail.com> wrote:
> On Fri, Apr 24, 2015 at 8:14 AM, arnaud gaboury
> <arnaud.gaboury@gmail.com> wrote:
>> On Thu, Apr 23, 2015 at 7:37 PM, arnaud gaboury
>> <arnaud.gaboury@gmail.com> wrote:
>>> On Thu, Apr 23, 2015 at 7:36 PM, Lennart Poettering
>>> <lennart@poettering.net> wrote:
>>>> On Thu, 23.04.15 19:29, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:
>>>>
>>>>> When in /var/lib/machines/poppy:
>>>>>
>>>>> root@hortensia ➤➤ machines/poppy # btrfs subvolume list .
>>>>> ID 266 gen 98 top level 5 path rootvol
>>>>> ID 268 gen 100 top level 5 path var
>>>>> ID 269 gen 101 top level 5 path etc
>>>>> ID 271 gen 72 top level 266 path var/lib/machines
>>>>> ID 272 gen 77 top level 268 path var/tmp
>>>>> ID 273 gen 77 top level 268 path var/lib/machines
>>>>>
>>>>> Anyone from the Btrfs ML to help ?
>>>>
>>>> Note that systemd-tmpfiles will create /var/tmp, and /var/lib/machines
>>>> as subvolumes these days, if they are missing and on btrfs.
>>>>
>>>
>>> OK, I understand these new subvol
>>
>> After cleaning everything, new install. Fedora 22 container boot but
>> then hangs: no login prompt.
>>
>> I did this:
>> enablerepo=fedora install systemd passwd dnf fedora-release-server
>>
>> Maybe did I forgot one essential repo?
>
> EDIT : if it can help:
>
> gabx@hortensia ➤➤ ~ % systemd-cgls
> ├─1 /usr/lib/systemd/systemd
> ├─machine.slice
> │ └─machine-poppy.scope
> │   ├─5654 /usr/lib/systemd/systemd
> │   └─system.slice
> │     ├─lvm2-lvmetad.service
> │     │ └─5678 /usr/sbin/lvmetad -f
> │     ├─systemd-journald.service
> │     │ └─5676 /usr/lib/systemd/systemd-journald
> │     └─dm-event.service
> │       └─5668 /usr/sbin/dmeventd -f

Issue solved:
Fedora release 22 (Twenty Two)
Kernel 3.19.3-3-apparmor on an x86_64 (console)

poppy login:

What I did: umount my two btrfs subvol
 # umount /var/lib/machines/poppy/etc
 # umount /var/lib/machines/poppy/var

then restart the container.

There is something weird with my btrfs settings.


>
>
>>
>> I will switch to Fedora ML now.
>> TY Lennart for your hints.
>>
>>>
>>>> Lennart
>>>>
>>>> --
>>>> Lennart Poettering, Red Hat
>>>
>>>
>>>
>>> --
>>>
>>> google.com/+arnaudgabourygabx
>>
>>
>>
>> --
>>
>> google.com/+arnaudgabourygabx
>
>
>
> --
>
> google.com/+arnaudgabourygabx



-- 

google.com/+arnaudgabourygabx
