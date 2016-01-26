Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58405 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965035AbcAZNIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 08:08:52 -0500
MIME-Version: 1.0
Message-ID: <trinity-9c913838-846a-4c07-b945-940d133c3771-1453813730632@3capp-gmx-bs37>
From: "Benjamin Draxlbauer" <Benjamin10@gmx.at>
To: linux-btrfs@vger.kernel.org
Subject: system not booting
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Jan 2016 14:08:50 +0100
References: <trinity-d93e5242-2f00-486d-a99c-3d1ab301d88f-1453812951676@3capp-gmx-bs37>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Everyone!
I coming from the opensuse mailing list with a critical problem with regard to btrfs… Below is the discussion and the trouble so far. 

Best, Benjamin.
 

>Gesendet: Dienstag, 26. Januar 2016 um 13:55 Uhr
>Von: "Benjamin Draxlbauer" <Benjamin10@gmx.at>
>An: opensuse@opensuse.org
>Betreff: Aw: Re: Re: Re: [opensuse] system not booting
>
>Morning Guys!
>I have a serious problem with my system: Today I wanted to start my system but after the bootmanager menue this message showed up:
> 
>Ignoring BGRT: invalid status 0 (expected 1)
>BTRFS (device sda3): parent transid verify failed on 35295068160 wanted 41939771539587072 found 2542
>BTRFS (device sda3): parent transid verify failed on 35295068160 wanted 41939771539587072 found 2542
>BTRFS: open_ctree failed
>Boot has failed. To debug this issue add "rd.shell rd.debug" to the kernel command line.
> 
>I tried it a few times but it didn't help. Actually i can't remember doing anything on my laptop, not even an update yesterday…
> 
>Best, Benjamin D.
>--
>To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
>To contact the owner, e-mail: opensuse+owner@opensuse.org
> 
>
>Gesendet: Dienstag, 26. Januar 2016 um 12:53 Uhr
>Von: "Bob Williams" <linux@karmasailing.uk>
>An: opensuse@opensuse.org
>Betreff: Re: Aw: Re: Re: [opensuse] system not booting
>On 26/01/16 11:13, Benjamin Draxlbauer wrote:
>
>
> Gesendet: Dienstag, 26. Januar 2016 um 11:37 Uhr
> Von: "Stanislav Baiduzhyi" <baiduzhyi.devel@gmail.com>
> An: opensuse <opensuse@opensuse.org>
> Betreff: Re: Re: [opensuse] system not booting
> On Tue, Jan 26, 2016 at 11:13 AM, Benjamin Draxlbauer <Benjamin10@gmx.at> wrote:
>> Thanks for the hint…Where should i add this line? I am not familiar on this type of stuff…
>
> you can try that from rescue cd, gparted-live-cd is my personal
> favourite, and do something like this in terminal:
> sudo su - root
> mkdir /mnt/sda3
> mount -t btrfs -o clear_cache /dev/sda3 /mnt/sda3
>
> if that command succeeds then clearing cache helped and you can try
> rebooting to your main system. Otherwise you have different problem,
> maybe someone else will be able to advice something.
> --
> To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
> To contact the owner, e-mail: opensuse+owner@opensuse.org
>
>
>
> Okay, i tried it within a terminal in ubunut which is the second system i am running on my laptop…
>
> sudo mount -t btrfs -o clear_cache /dev/sda3 /mnt/sda3
> mount: Falscher Dateisystemtyp, ungültige Optionen, der
> Superblock von /dev/sda3 ist beschädigt, fehlende
> Kodierungsseite oder ein anderer Fehler
> Manchmal liefert das Systemprotokoll wertvolle Informationen,
> versuchen Sie »dmesg | tail« oder so
>
> and dmesg tells the following:
>
> dmesg | tail
> [ 514.164113] parent transid verify failed on 35295068160 wanted 41939771539587072 found 25424
> [ 514.164117] BTRFS: failed to read chunk root on sda3
> [ 514.182238] BTRFS: open_ctree failed
> [ 593.703113] BTRFS info (device sda3): force clearing of disk cache
> [ 593.703118] BTRFS info (device sda3): disk space caching is enabled
> [ 593.703120] BTRFS: has skinny extents
> [ 593.711602] parent transid verify failed on 35295068160 wanted 41939771539587072 found 25424
> [ 593.723735] parent transid verify failed on 35295068160 wanted 41939771539587072 found 25424
> [ 593.723742] BTRFS: failed to read chunk root on sda3
> [ 593.741048] BTRFS: open_ctree failed
>
> Almost the same as in my first mail…Any suggestions? This looks quite critical…and…i don't have a recent update!!!
>

>You haven't mentioned which version of opensuse you are running, and
>more importantly, which kernel.

>You'll probably get more help on the linux-btrfs@vger.kernel.org list.
>First question they'll ask is are you running an up to date kernel and
>an up to date version of btrfs-progs.
>
>Bob
>--
>Bob Williams
>System: Linux 4.1.13-5-default
>Distro: openSUSE 42.1 (x86_64) with KDE Development Platform: 4.14.10
>
>
>Thanks for the hint…
>Here are my specs:
>
>System: Opensuse 42.1 Leap
>KDE Plasma: 5.4.3
>Qt: 5.5.1
>Kernel: 4.3.0-2-default

>unfortunately I have no access to my system, so I do not know which versions of btrfs-progs i have. But my system is up to date (lateste update 2 days ago).
>Thanks!
> 
>(sorry Bob for sending you a private mail…was a mistake!)
>--
>To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
>To contact the owner, e-mail: opensuse+owner@opensuse.org
