Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:42607 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3F3ROd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 13:14:33 -0400
Message-ID: <1372612472.13762.18.camel@miguel-MacBookPro>
Subject: btrfs send /receive : having problems sending a snapshot back to
 the original partition
From: Miguel =?ISO-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
To: btrfs list <linux-btrfs@vger.kernel.org>
Date: Sun, 30 Jun 2013 18:14:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I'm now sucessfully backing up my ubuntu machine using btrfs send and
btrfs receive. Essentially I do 

mount /dev/sda3 /mnt
cd /mnt
btrfs subvolume snapshot @ backups/@-backupNew
btrfs send -p backups/@-backupOld backups/@-backupNew | pv | btrfs
receive /media/miguel/huge/backups/@

This is working great and most sends take less then a minute. I did a
diff of the original with the send snapshot and except for sockets and
other "weird" files like in /dev all the other files seem to be exactly
the same.

Now I was testing retrieving a snapshot back from the backup disk to the
original partition:

If I do 

btrfs subvolume delete @-backupOld

and then do

btrfs send
-p /media/miguel/huge/backups/@/@-backupNew /media/miguel/huge/backups/@/@-backupOld | pv | btrfs receive/mnt/backups

I get an error: 

ERROR: could not find parent subvolume

Sending via files instead of pipes I can see the error is in btrfs
receive, the btrfs send completes without errors.

Is it what I'm trying to do not possible ? I'm I using the wrong
syntax ? It would be really handy to be able to do this, to make it easy
to go to an old snapshot without having to transfer it in it's full
size, instead transferring just the diff.

Also, how is the -c (clone) option used and does it do ? It's not clear
to me what is it's function, and I haven't seen any example using it on
the web.

thanks,

-- 
Miguel Negrão
http://www.friendlyvirus.org/miguelnegrao


ps: I've set up a Haskell script to do the backups, in case it interests
anyone it's here: https://gist.github.com/miguel-negrao/5895613

