From: =?ISO-8859-15?Q?Bj=F6rn_Kalkbrenner?= <terminar@cyberphoria.org>
Subject: Problems with set-default, home subvolume and snapshot
Date: Mon, 05 Sep 2011 12:13:25 +0200
Message-ID: <4E64A0C5.2060409@cyberphoria.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i've got an interesting btrfs subvolume problem which i can't
understand... Maybe someone here can give me a tip because i think
that's only a user error...

I had a root btrfs on / and made a subvolume some month ago for my home
on /home (i think cwd was / and i used "btrfs subvolume create /home").

On friday i wanted to try an update of my distribution, so i
created a snapshot on /snapshots/20110902 (cwd was / and i entered
"btrfs subvolume snapshot / /snapshots/20110902).

Today i realized that my update failed, so i did
"btrfs set-default 257 /" (257 is the id of the snapshot from friday)..=
=2E

When i rebooted, the trouble began. The mounted "home" subvolume was
empty (even if mounted) and the new root from today which i used before
trying the set-default seems to be lost. Ok, not the main problem...

The snapshot from friday was mounted correctly on boot as root.

The directory /snapshots/20110902 is empty but it is still listed as
subvolume. My "home" was also empty but still listed as subvolume.
I tried to remove the subvolume, i tried to remove the directory, both
not working.

Then i tried to
"mount -o subvolumeid=3D256 /dev/mapper/root /home" (id of home subvol)
and the content of my home is back...


My questions are:

1. where is the "original" root from today morning before i did
set-default? Lost?

2. why can't i do "mount -o subvolume=3Dhome /dev/mapper/root /home"
anymore? To be more exact, i can, but why is it empty and why is it
working when i enter the subvolume id?

3. I am now using the snapshot /snapshots/20110902 but what is
/snapshots/20110902 now and why is it still listed? It's empty?

4. can i now delete the snapshots/20110902 or will that drop my current
active working root?

5. can i rename snapshots, e.g. the snapshots/20110902 or "home" to
"home-20110905"?

6. is my btrfs filesystem broken now and should i recreate the whole
thing or is it safe to use it?

Bye
Bj=F6rn
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
