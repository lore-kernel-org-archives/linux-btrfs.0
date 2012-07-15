Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56023 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2GOOFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jul 2012 10:05:03 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org,
        "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
Subject: Re: btrfsck crashes
Date: Sun, 15 Jul 2012 16:05:00 +0200
Cc: Anand Jain <Anand.Jain@oracle.com>
References: <4FF9B07C.8090209@cv-sv.de> <4FFD278D.20804@oracle.com> <209200388.295540.1341995780489.JavaMail.open-xchange@email.1und1.de> (sfid-20120711_103927_662447_62FDD5CB)
In-Reply-To: <209200388.295540.1341995780489.JavaMail.open-xchange@email.1und1.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207151605.01189.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 11. Juli 2012 schrieb haveaniceday@cv-sv.de:
> PS: I would bet that my kind of usage is a very good stress test for
> btrfs.
> 
> - large file system "/backup" btrfs with compress enabled.
> 
> Content of the file system:
> - ./server1 .... /server5  as directories
> - for each server the directory has a structure like this:
>   backup-YYYY-DD-MM-HH:M
>   New backups are created with:
>   rsync -axvH --link-dest=/backup/server'n'/backup-...(old, last dir)..
>   server:/   /backup/server'n'/backup-YYY-.../.
> 
> This generates files with a large number of hard links.

I am using

btrfs subvolume snapshot -r

after a rsync backup for exact this case.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
