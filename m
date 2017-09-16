Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:47431 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdIPJpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 05:45:05 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9F0C389FB
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 11:45:04 +0200 (MEST)
Date: Sat, 16 Sep 2017 11:45:04 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: subvolume list as user?
Message-ID: <20170916094504.GL32347@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Every user can create subvolumes (and root cannot prevent it!).
But how can a user list these subvolumes?

tux@xerus:/test/tux: btrfs subvolume create test
Create subvolume './test'

tux@xerus:/test/tux: btrfs subvolume list .
ERROR: can't perform the search - Operation not permitted


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de
REF:<20170916094504.GL32347@rus.uni-stuttgart.de>
