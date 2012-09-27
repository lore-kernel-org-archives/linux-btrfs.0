Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.inserm.fr ([195.98.252.37]:35367 "EHLO smtp.inserm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab2I0Kob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 06:44:31 -0400
Message-ID: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
Date: Thu, 27 Sep 2012 12:44:27 +0200
From: =?utf-8?b?U8OpYmFzdGllbg==?= Maury <sebastien.maury@inserm.fr>
To: linux-btrfs@vger.kernel.org
Cc: sebastien.maury@inserm.fr
Subject: BTRF - Storage Usage
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've installed a new server using btrfs for my root partition ("/").

It uses snapper for snapshots management and all seems to work pretty fine.

My problem is to be able to know the remaining REAL free space in my  
partition.

Using different commands, i have different results, and i don't know  
how to interpret them correctly :
poivron:~ # btrfs filesystem df /
Data: total=4.01GB, used=2.16GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.00GB, used=429.16MB
Metadata: total=8.00MB, used=0.00

poivron:~ #  df -hP /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       132G  3.0G  124G   3% /

poivron:~ # btrfs filesystem show /dev/sda3
Label: none  uuid: 9e68b667-f9f9-490f-9da1-ae4e91558212
         Total devices 1 FS bytes used 2.58GB
         devid    1 size 131.64GB used 10.04GB path /dev/sda3

Btrfs v0.19+

poivron:~ # du -sh /.snapshots
40G     /.snapshots

===========

Please help me understand and interpret those information to know the  
most accurately as possible what is my real remaining space, and what  
space is used by what.

Although, i don't really understand the output of the command "btrfs  
filesystem df /" : what are exactly "Data", "System DUP", "System  
total", "Metadata DUP" and "Metadata total" ?

==========

Here are some complementary informations :
poivron:~ # uname -a
Linux poivron 3.0.26-0.7-default #1 SMP Tue Apr 17 10:27:57 UTC 2012  
(3829766) x86_64 x86_64 x86_64 GNU/Linux

poivron:~ # snapper list-configs
Config        | Subvolume
--------------+------------------------
root          | /

poivron:~ # cat /etc/snapper/configs/root

# subvolume to snapshot
SUBVOLUME="/"

# filesystem type
FSTYPE="btrfs"


# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="100"


# create hourly snapshots
TIMELINE_CREATE="yes"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="10"
TIMELINE_LIMIT_DAILY="10"
TIMELINE_LIMIT_MONTHLY="10"
TIMELINE_LIMIT_YEARLY="10"


# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="1800"


Cordialement,

Sébastien MAURY
Responsable d'exploitation du site de Montpellier
Équipe DBA
___________________________________
INSERM - DSI - Pôle Infrastructures

Délégation régionale Languedoc Roussillon
60, rue de Navacelles
34394 Montpellier Cedex 5

Mob : 06 31 51 42 18
Fixe : 04 67 63 61 43
Fax : 04 67 63 70 25
Mél : sebastien.maury@inserm.fr
___________________________________


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


