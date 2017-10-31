Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta02.helmholtz-muenchen.de ([146.107.4.101]:37878 "EHLO
        mta02.helmholtz-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753584AbdJaQyg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 12:54:36 -0400
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.105])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mta02.helmholtz-muenchen.de (Postfix) with ESMTP id 76DA9317EE2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:40:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 8926B144B34
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:34 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id MbktB7aZPXvJ for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 17:54:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaextp1.scidom.de (Postfix) with ESMTP id 03C3214490E
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:31 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
        by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id u97w5_b0mGss for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.104])
        by mtaextp1.scidom.de (Postfix) with ESMTPS id AEE6B144B34
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id A4FE3100662
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jfJ-3Cq6qe5b for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 3C598100669
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
        by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id op-aUyFrn0jC for <linux-btrfs@vger.kernel.org>;
        Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.101])
        by mtaintp1.scidom.de (Postfix) with ESMTP id 1E0FC100648
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:54:30 +0100 (CET)
Date: Tue, 31 Oct 2017 17:54:29 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <551550025.428652.1509468869372.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com> <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de> <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com>
Subject: Re: btrfs-subv-backup v0.1b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----- On Oct 31, 2017, at 2:59 PM, Austin S. Hemmelgarn ahferroin7@gmail.com wrote:

>> Hi Austin,
>> 
>> thanks for your effort. What are the minimum prerequesties for kernel and
>> btrfsprogs for that script ?
>> Do you think it will run on my old SLES 11 SP4 ?
> Dependency-wise, it needs:
> 
> kernel: Should work with any kernel version that has BTRFS support,
> untested on kernels before 4.10, but I'm fairly confident that it should
> work on just about anything.  If there's going to be a failure due to
> kernel version, it should happen when saving the subvolume information,
> so you should be safe checking this (especially since the script doesn't
> write anything when saving the info until the very end, and doesn't use
> any write capable ioctls when fetching the info).
> 
> btrfs-progs: Only uses the subvolume list, create, and delete commands,
> and the only one which may have changed significantly in the past few
> years is the list command.  I've only tested it with btrfs-progs 4.10.2
> and newer, but I expect it should work with any of them at least since
> the change to matching kernel versions.  You can quickly check this by
> making sure the output of `btrfs subvolume list` looks like this:
> 
>     ID 257 gen 769304 top level 5 path root
> 
> What matters there is the number of words between each number, as the
> parsing code is pretty naive.
> 
> util-linux: We use blkid to get the filesystem label and UUID so that
> it's more evident in the file what filesystem it's for (in case you
> decide to stroe them separately), but as far as I know the relevant
> command-line options haven't changed in at least half a decade, so any
> reasonably recent version should work fine (tested with util-linux
> 2.31).  As the script is currently, this will cause it to throw an
> exception if it doesn't work, but that will happen before it does almost
> anything else, so it should still fail safe.
> 
> Python: btrfs-subv-backup requires Python 3.  I've only tested it on 3.4
> and 3.6, but I'm pretty sure it should work on most versions back to at
> least 3.2.  Of the dependencies, this is the one I'd expect to be the
> most likely possible issue on older distros, but you likely have a new
> enough version already given the kernel build date shown below.  If this
> doesn't work, you will get syntax errors (specifically around the error
> handlers).
> 

damned, i have 2.6.9 and the most recent i fnd in repositories for SLES 11 SP4 is 2.7.6

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

