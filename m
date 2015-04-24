Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta02.helmholtz-muenchen.de ([146.107.4.101]:49232 "EHLO
	mta02.helmholtz-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbbDXOxl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 10:53:41 -0400
Received: from XCH21.scidom.de (xch21.helmholtz-muenchen.de [146.107.8.221])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mta02.helmholtz-muenchen.de (Postfix) with ESMTP id CF8DB317471
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 16:23:35 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Date: Fri, 24 Apr 2015 16:26:03 +0200
Subject: rollback of a snapshot is just read-only
Message-ID: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DB@XCH11.scidom.de>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

it should be just a small problem, but it is one. How can I rollback to a snapshot of my root filesystem ?
Googeling, I found a lot of solutions, each different.
I finally choosed this one: https://btrfs.wiki.kernel.org/index.php/UseCases#I_want_to_be_able_to_do_rollbacks_with_Btrfs

I made the snapshot, changed some configuration, and afterwards I'd like to rollback to the snapshot:

- btrfs subvolume snapshot -r  /  /.snapshots/vor_nvidia

- change some configuration

- btrfs subvolume set-default 625 (id of the snapshot)

- reboot

My /-folder is again the old one, that's ok. The change of the configuration has disappeared. But it is just read-only:
pc63422:~ # touch /test
touch: cannot touch '/test': Read-only file system

mount says:

...
/dev/sda1 on /  type btrfs (rw,ssd,space_cache)
...

It seems to be rw !?

OS: SLES 12 64bit
kernel: 3.12.38-44-default

pc63422:~ # rpm -qa|grep -i btrfs
btrfsprogs-3.16.2-7.1.x86_64
libbtrfs0-3.16.2-7.1.x86_64
btrfsmaintenance-0.1-7.1.noarch

pc63422:~ # btrfs --version
Btrfs v3.16.2+20150127

pc63422:~ # btrfs fi show
Label: none  uuid: 7edcb64a-4ca6-47ec-8979-54e158c96ac2
        Total devices 1 FS bytes used 145.19GiB
        devid    1 size 450.00GiB used 150.04GiB path /dev/sda1

pc63422:~ # btrfs fi df /
Data, single: total=146.01GiB, used=142.74GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=4.00GiB, used=2.44GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Thanks for any hint.


Bernd

--
Bernd Lentes

Systemadministration
Institut für Entwicklungsgenetik
Gebäude 35.34 - Raum 208
HelmholtzZentrum münchen
bernd.lentes@helmholtz-muenchen.de
phone: +49 89 3187 1241
fax:   +49 89 3187 2294
http://www.helmholtz-muenchen.de/idg

Je suis Charlie



Helmholtz Zentrum München
Deutsches Forschungszentrum für Gesundheit und Umwelt (GmbH)
Ingolstädter Landstr. 1
85764 Neuherberg
www.helmholtz-muenchen.de
Aufsichtsratsvorsitzende: MinDir´in Bärbel Brumme-Bothe
Geschäftsführer: Prof. Dr. Günther Wess, Dr. Nikolaus Blum, Dr. Alfons Enhsen
Registergericht: Amtsgericht München HRB 6466
USt-IdNr: DE 129521671
