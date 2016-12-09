Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:36099 "EHLO smtp2.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932245AbcLILCV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Dec 2016 06:02:21 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp2.belwue.de with SMTP id uB9B2Dhv000460
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 12:02:13 +0100 (MET)
        env-from (framstag@rus.uni-stuttgart.de)
Date: Fri, 9 Dec 2016 12:02:13 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: autoversioning?
Message-ID: <20161209110213.GA21685@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is file autoversioning possible with btrfs?

I have a VMS background, where the standard filesystem automatically
creates a new version for every file that is written.

The number of versions can be controlled globally, on directory or on file
base.

With btrfs I can create manually a file version (clone) with
"cp -a --reflink"
but I want this to be done automatically.

I could set up an incron-job (inotify), but perhaps there is a better,
easier solution?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20161209110213.GA21685@rus.uni-stuttgart.de>
