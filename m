Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:33175 "EHLO smtp2.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753580AbcKYIz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:55:29 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp2.belwue.de with SMTP id uAP8SehB019208
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 09:28:40 +0100 (MET)
        env-from (framstag@rus.uni-stuttgart.de)
Date: Fri, 25 Nov 2016 09:28:40 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: mount option nodatacow for VMs on SSD?
Message-ID: <20161125082840.GA32711@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have vmware and virtualbox VMs on btrfs SSD.

I read in
https://btrfs.wiki.kernel.org/index.php/SysadminGuide#When_To_Make_Subvolumes

     certain types of data (databases, VM images and similar typically big
     files that are randomly written internally) may require CoW to be
     disabled for them.  So for example such areas could be placed in a
     subvolume, that is always mounted with the option "nodatacow".

Does this apply to SSDs, too?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20161125082840.GA32711@rus.uni-stuttgart.de>
