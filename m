From: birger <birger@birger.sh>
Subject: birgers RFE #3
Date: Tue, 03 Aug 2010 14:52:34 +0200
Message-ID: <1280839954.31210.18.camel@sch30110.bergens-tidende.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My last one for now...

I see from the project ideas list that some of what I want is there
already in the "Incremental backups" section. What is missing is the
ability to create a new subvol at the remote end given an existing
volume with a common subvolume to work from.

Some kind of UUID-like fingerprint on each subvolume to be sure both
ends use the same subvolume as base, or some way to make new subvolumes
at the remote end have the same ID number would be necessary, I think?

It should then be possible to make a script that finds a common base on
both sides and uses the already proposed rsync filelist to create new
subvolume(s) on the remote end and populate those with only an
incremental data push.

-- 
birger


