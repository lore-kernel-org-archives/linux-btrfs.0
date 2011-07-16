From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: write(2) taking 4s. (Was: Memory leak?)
Date: Sat, 16 Jul 2011 13:12:10 +0100
Message-ID: <20110716121210.GA5638@yahoo.fr>
References: <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
 <20110711090121.GA2537@yahoo.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110711090121.GA2537@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Still on my btrfs-based backup system. I still see one BUG()
reached in btrfs-fixup per boot time, no memory exhaustion
anymore. There is now however something new: write performance
is down to a few bytes per second.

I've got a few processes (rsync, patched ntfsclone, shells
mostly) writing to files at the same time on this server.

disk stats per second:

--dsk/sda-----dsk/sdb-----dsk/sdc--
 read  writ: read  writ: read  writ
 264k   44k: 193k   44k: 225k   42k
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0    60k:   0     0 :   0     0
   0    12k:   0  1176k:   0  1164k
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0    40k:   0     0 :8192B    0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :4096B    0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
 324k    0 : 248k    0 : 548k    0
   0  4096B:   0     0 :   0     0
 352k    0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0
   0     0 :   0     0 :4096B    0
   0     0 :   0     0 :   0     0
   0    80k:   0     0 :   0     0

rsync:

# strace -Ts0 -p 5015
Process 5015 attached - interrupt to quit
write(3, ""..., 1024)                   = 1024 <0.007700>
write(3, ""..., 1024)                   = 1024 <0.015822>
write(3, ""..., 1024)                   = 1024 <0.031853>
write(3, ""..., 1024)                   = 1024 <0.015881>
write(3, ""..., 1024)                   = 1024 <0.015911>
write(3, ""..., 1024)                   = 1024 <0.015796>
write(3, ""..., 1024)                   = 1024 <0.031946>
write(3, ""..., 1024)                   = 1024 <4.083854>
write(3, ""..., 1024)                   = 1024 <0.007925>
write(3, ""..., 1024)                   = 1024 <0.003776>
write(3, ""..., 1024)                   = 1024 <0.031862>
write(3, ""..., 1024)                   = 1024 <0.011807>
write(3, ""..., 1024)                   = 1024 <0.019742>
write(3, ""..., 1024)                   = 1024 <0.015857>
write(3, ""..., 1024)                   = 1024 <0.031833>
write(3, ""..., 1024)                   = 1024 <0.015789>
write(3, ""..., 1024)                   = 1024 <0.015926>
write(3, ""..., 1024)                   = 1024 <4.095967>
write(3, ""..., 1024)                   = 1024 <0.019798>
write(3, ""..., 1024)                   = 1024 <4.083682>
write(3, ""..., 1024)                   = 1024 <0.015398>
write(3, ""..., 1024)                   = 1024 <0.015951>
write(3, ""..., 1024)                   = 1024 <0.035837>
write(3, ""..., 1024)                   = 1024 <0.015962>
write(3, ""..., 1024)                   = 1024 <0.015909>
write(3, ""..., 1024)                   = 1024 <0.015967>
write(3, ""..., 48)                     = 48 <0.003782>
write(3, ""..., 1024)                   = 1024 <0.031802>
write(3, ""..., 1024)                   = 1024 <0.015811>
write(3, ""..., 1024)                   = 1024 <0.015944>
write(3, ""..., 1024)                   = 1024 <0.019810>
write(3, ""..., 1024)                   = 1024 <0.031948>

ntfsclone (patched to only write modified clusters):

# strace -Te write -p 4717
Process 4717 attached - interrupt to quit
write(1, " 65.16 percent completed\r", 25) = 25 <0.008996>
write(1, " 65.16 percent completed\r", 25) = 25 <0.743358>
write(1, " 65.16 percent completed\r", 25) = 25 <0.306582>
write(1, " 65.17 percent completed\r", 25) = 25 <4.082723>
write(1, " 65.17 percent completed\r", 25) = 25 <0.006402>
write(1, " 65.17 percent completed\r", 25) = 25 <0.012582>
write(1, " 65.17 percent completed\r", 25) = 25 <4.052504>
write(1, " 65.17 percent completed\r", 25) = 25 <0.012111>
write(1, " 65.17 percent completed\r", 25) = 25 <0.016001>
write(1, " 65.17 percent completed\r", 25) = 25 <4.028017>
write(1, " 65.18 percent completed\r", 25) = 25 <0.013365>
write(1, " 65.18 percent completed\r", 25) = 25 <0.003963>
(that's writing to a log file)

See how many write(2)s take 4 seconds.

No issue when writing to an ext4 FS.

SMART status on all drives OK.

What else could I look at?

Attached is a sysrq-t output.

-- 
Stephane

--ibTvN161/egqYuK8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="sysrq-t.txt.xz"
Content-Transfer-Encoding: base64

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
+texxGf7AgAAAAAEWVo=

--ibTvN161/egqYuK8--
