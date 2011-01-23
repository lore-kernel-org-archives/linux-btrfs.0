From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: snapshot strange behaviour
Date: Sun, 23 Jan 2011 07:17:15 +0000 (UTC)
Message-ID: <ihgklr$s29$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

During doing backups I found strange behaviour... 2.6.37, latest btrfs-
progs from git

nbgentoo ~ # btrfs subv crea a
Create subvolume './a'
nbgentoo ~ # cd a
nbgentoo a # btrfs subv crea b
Create subvolume './b'
nbgentoo a # touch b/file
nbgentoo a # ls -l b/
total 0
-rw-r--r-- 1 root root 0 Jan 23 08:14 file
nbgentoo a # cd ..
nbgentoo ~ # btrfs subv snap a x
Create a snapshot of 'a' in './x'
nbgentoo ~ # ls -l x/b/
total 0

and also

nbgentoo ~ # cd x/
nbgentoo x # btrfs subv dele b 
ERROR: 'b' is not a subvolume

Is this a bug or intended behaviour and I am missing something something?
How to snapshot a subvolume, containing another subvolumes?

(I create subvolume backup, under this another subvolumes as not always I 
want to snapshot the whole backup subvolume).

Thank you

Lubos

