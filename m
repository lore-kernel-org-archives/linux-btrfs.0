Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58225 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2ISH2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 03:28:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TEEhn-0004RL-K2
	for linux-btrfs@vger.kernel.org; Wed, 19 Sep 2012 09:28:19 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 09:28:19 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 09:28:19 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bang <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Wed, 19 Sep 2012 07:28:05 +0000 (UTC)
Message-ID: <loom.20120919T083653-817@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <5058068C.4040704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Anand Jain <Anand.Jain <at> oracle.com> writes:
>   archive-log-apply script - if you could, can you share the
>   script itself ? or provide more details about the script.
>   (It will help to understand the work-load in question).

Our setup entails a whole bunch of scripts, but the apply script looks like this 
(orion is the production environment, pandium is the shadow):
http://pastebin.com/k4T7deap

The script invokes rman passing rman_recover_database.rcs:

connect target /
run {
    crosscheck archivelog all;
    delete noprompt expired archivelog all;
    catalog start with '/backup/oracle/flash_recovery_area/FROM_PROD/archivelog' 
noprompt;
    recover database;
}

We receive a 1GB archivelog roughly every 20'th minute, depending on the 
workload of the production environment. Apply rate starts out fine with btrfs > 
ext4 > zfs, but ends out with ZFS > ext4 > btrfs. The following numbers are from 
our consumer spinning-platter disk test, but they are equally representable to 
the SSD numbers we got.

Ext4 starts out with a realtime to SCN ratio of about 3.4 and ends down around a 
factor 2.2.

ZFS starts out with a realtime to SCN ratio of about 7.5 and ends down around a 
factor 4.4.

Btrfs starts out with a realtime to SCN ratio of about 2.2 and ends down around 
a factor 0.8. This of course means we will never be able to catch up with 
production, as btrfs can't apply these as fast as they're created.

It was even worse with btrfs on our 10xSSD server, where 20 min. of realtime 
work would end up taking some 5h to get applied (factor 0.06), obviously useless 
to us.

I should point out, that during this process we also had to move some large 
backup sets around and we saw several times btrfs eating massive IO never to 
finish a simple mv command.

I'm inclined to believe we've found some weak corner, perhaps in combination 
with SSD's - but it led us to compare with ext4 and ZFS, and dismiss btrfs for 
this over ZFS as it solves our problem.

