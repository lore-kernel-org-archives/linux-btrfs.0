From: "Helmut Hullen" <Hullen@t-online.de>
Subject: labelling
Date: 10 Nov 2010 08:40:00 +0100
Message-ID: <B$bGt2my1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I have problems with btrfs labels.

My way:

2-TByte-disk:

        mkfs.btrs LABEL=MM2 /dev/sdd2

worked.
Mounting "mount LABEL=MM2 /srv/MM" worked.

Additional 1.5-TByte-Disk:

        btrfs add device /dev/sdc3 /srv/MM
        ... balance ...

worked.

        findfs LABEL=MM2

shows "/dev/sdd2" (the first partition)

        file -s /dev/sdd2
        file -s /dev/sdc3

shows "LABEL=MM2" for both partitions (that's not good).

Unmounting "/srv/MM" and

        mount LABEL=MM2 /srv/MM

doesn't work now, it tries to mount /dev/sdd2 and mourns.

        mount /dev/sdd2 /srv/MM

shows the same error message,

        mount /dev/sdc3 /srv/MM

(mounting the added partition) works fine, the whole space is available.

But what can I do with the 2 identical labels? How can I delete (or  
change) the label of the first btrfs partition?

----------------------------

By the way:

"df" shows about 3.4 TByte usable space (2 TByte and 1.5 TByte), but

        btrfs filesystem df /srv/MM

tells

        Data: total=2.70TB, used=1.64TB

I'm missing about 0.7 TByte!

Viele Gruesse!
Helmut
