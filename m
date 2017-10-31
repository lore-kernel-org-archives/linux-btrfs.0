Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta02.helmholtz-muenchen.de ([146.107.4.101]:34906 "EHLO
        mta02.helmholtz-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751269AbdJaNFX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:05:23 -0400
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.105])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mta02.helmholtz-muenchen.de (Postfix) with ESMTP id 15AC73190C1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:26:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id C3BB9144CB2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:40 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iwJbpfbZsn-2 for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 13:40:38 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id B0D3C144C99
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:38 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7akqBkeXhCYz for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 13:40:38 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id 7C86814494A
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:38 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 6FDF410009B
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:38 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jHVbNRQ-YAJu for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 13:40:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id BD88B100489
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:37 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3unx-C3m3Nnb for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 13:40:37 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id A1D2810009B
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 13:40:37 +0100 (CET)
Date: Tue, 31 Oct 2017 13:40:37 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
Subject: Re: btrfs-subv-backup v0.1b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



----- Am 26. Okt 2017 um 15:32 schrieb Austin S. Hemmelgarn ahferroin7@gmail.com:

> As previously mentioned on the list, I've written up a script to back up
> BTRFS subvolume structures in regular file-based backups.  As of right
> now, it's still a bit rough around the edges, but it's cleaned up enough
> that I consider it of at least beta quality, and therefore fit for more
> general testing (and possibly usage).   Aside from the issues and
> limitations listed below in the README, error checking is still somewhat
> lacking, and I plan to remedy that in the near future.
> 
> The script itself can be found here:
> https://github.com/Ferroin/btrfs-subv-backup
> 
> Here's the official README, as that already covers pretty much
> everything else I would put in this e-mail:
> 
> # btrfs-subv-backup v0.1b
> btrfs-subv-backup is a tool for recording the layout of subvolumes on
> a mounted BTRFS filesystem in a way that can be stored in a regular
> file-based backup (for example, using tar).  It originated out of a lack
> of such existing tools, and is intended to be as portable as reasonably
> possible.  As a result, it depends on nothing beyond a working
> installation of Python version 3.4 or higher.
> 
> btrfs-subv-backup is licensed under a BSD-style license, check the
> LICENSE file or the docstring for more information.
> 
> ### Usage
> Usage is extremely simple.  To generate a backup of a given mount
> point, run:
> 
> `btrfs-subv-backup.py /path`
> 
> This will create a file called `.btrfs-subv-backup.json` in the root of
> the mount point, make sure that gets included in any backups you run of
> the mount point.
> 
> To restore the subvolumes in a filesystem after you've extracted a backup
> of the mount point, run:
> 
> `btrfs-subv-backup.py --restore /path`
> 
> This will recreate the subvolume structure.
> 
> If you need to manually recreate the subvolumes, you can find a list
> of them in the aforementioned JSON file under the 'subvolumes' key (the
> other keys store info about the filesystem itself to make it easier to
> figure out what it was).
> 
> ### Limitations and Known Issues
> * We don't store information about reflinks.  This means in particular
> that snapshot relationships __ARE NOT__ saved.  There is currently no
> way to store this data reliably short of a block-level backup, which
> has it's own special issues.
> * Subvolumes with spaces in their name are not supported.
> * There is currently no indication of progress.
> * The restoration process may take a long time, and may use a very large
> amount of disk space.  Ideally this should be fixed, but I'm not sure
> of any way to do so while keeping things on-line.
> * The current restoration process is all-or-nothing, things are not
> correctly handled if some of the subvolumes have already been restored
> (although btrfs-subv-backup will clean up the temporary subvolumes it
> creates during the restore if the restore fails).  This should be pretty
> easy to fix, I just haven't gotten around to it yet.
> * btrfs-subv-backup won't cross actual mount points, which means it
> won't recurse into explicitly mounted subvolumes.  This makes usage a
> bit more complicated on some distributions (such as SLES and OpenSUSE),
> but greatly simplifies the code.

Hi Austin,

thanks for your effort. What are the minimum prerequesties for kernel and btrfsprogs for that script ?
Do you think it will run on my old SLES 11 SP4 ?

ha-idg-1:~ # rpm -qa|grep -i btrfs
btrfsprogs-3.18.2-0.40.48
btrfsmaintenance-0.1-3.1
libbtrfs0-3.18.2-0.40.48

ha-idg-1:~ # uname -a
Linux ha-idg-1 3.0.101-100-default #1 SMP Tue Apr 18 22:46:01 UTC 2017 (ce95309) x86_64 x86_64 x86_64 GNU/Linux

Bernd
 

Helmholtz Zentrum Muenchen
Deutsches Forschungszentrum fuer Gesundheit und Umwelt (GmbH)
Ingolstaedter Landstr. 1
85764 Neuherberg
www.helmholtz-muenchen.de
Aufsichtsratsvorsitzende: MinDir'in Baerbel Brumme-Bothe
Geschaeftsfuehrer: Prof. Dr. Guenther Wess, Heinrich Bassler, Dr. Alfons Enhsen
Registergericht: Amtsgericht Muenchen HRB 6466
USt-IdNr: DE 129521671

