Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:39890 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbBHPfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 10:35:54 -0500
Received: by mail-ig0-f172.google.com with SMTP id l13so11818807iga.5
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 07:35:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <trinity-eca39016-0bbe-4b48-bf9b-0f8891294c3a-1423408648492@3capp-webde-bs08>
References: <trinity-eca39016-0bbe-4b48-bf9b-0f8891294c3a-1423408648492@3capp-webde-bs08>
Date: Sun, 8 Feb 2015 09:35:53 -0600
Message-ID: <CAE5mzvibkSU7_qdUMQUfNEaP83J1wVuZ4P1-JTY3yb+7ghv9OA@mail.gmail.com>
Subject: Re: Replicate snapshot to second machine fails
From: cwillu <cwillu@cwillu.com>
To: Thomas Schneider <c.monty@web.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This isn't a btrfs-send or a btrfs-receive question:

$ echo hi | ssh machine.local sudo echo test
sudo: no tty present and no askpass program specified

How were you planning on providing credentials to sudo?

On Sun, Feb 8, 2015 at 9:17 AM, Thomas Schneider <c.monty@web.de> wrote:
>
>
> Hi,
>
> I want to replicate a snapshot from PC1 to virtual machine using this command:
>
> user@pc1-gigabyte ~ $ sudo btrfs send "/home/.snapshots/lmde_home_2015-02-07_02:38:21" | ssh vm1-debian sudo btrfs receive /home/.snapshots/
> At subvol /home/.snapshots/lmde_home_2015-02-07_02:38:21
> sudo: Kein TTY vorhanden und kein »askpass«-Programm angegeben
>
> Unfortunately I cannot detect the root cause for the failure.
> Any ideas?
>
> On both machines I have installed programs ssh-askpass and ssh-askpass-gnome.
>
>
> user@pc1-gigabyte ~ $ uname -a
> Linux pc1-gigabyte 3.16.0-4-686-pae #1 SMP Debian 3.16.7-ckt2-1 (2014-12-08) i686 GNU/Linux
> user@pc1-gigabyte ~ $ sudo btrfs --version
> Btrfs v3.17
> user@pc1-gigabyte ~ $ sudo btrfs fi show
> Label: none  uuid: 236fe36a-3187-4955-977d-f22cd818c424
>     Total devices 1 FS bytes used 103.96GiB
>     devid    1 size 147.00GiB used 147.00GiB path /dev/sda5
> Btrfs v3.17
> user@pc1-gigabyte ~ $ sudo btrfs fi df /home
> Data, single: total=142.97GiB, used=103.03GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=2.00GiB, used=957.17MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=320.00MiB, used=0.00B
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
