Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35976 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdIJHKk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 03:10:40 -0400
Received: by mail-lf0-f46.google.com with SMTP id m199so12430299lfe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 00:10:39 -0700 (PDT)
Received: from m5-242-50-84.cust.tele2.se ([2a00:801:218:be1:f9d1:56e2:82f6:ef39])
        by smtp.googlemail.com with ESMTPSA id p67sm967666lfe.77.2017.09.10.00.10.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256/256);
        Sun, 10 Sep 2017 00:10:36 -0700 (PDT)
Date: Sun, 10 Sep 2017 09:10:36 +0200 (GMT+02:00)
From: A L <crimsoncottage@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <1f32817.7758af29.15e6aa02e3c@gmail.com>
In-Reply-To: <20170909195206.GA11461@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de> <20170909132614.GA20299@rus.uni-stuttgart.de> <20170909133612.7iqwr6cbjxzvfny6@merlins.org> <20170909134426.GB20299@rus.uni-stuttgart.de> <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com> <20170909195206.GA11461@rus.uni-stuttgart.de>
Subject: Re: netapp-alike snapshots?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Perhaps netapp is using a VFS overlay. There is really only one snapshot but it is shown in the overlay on every folder. Kind of the same with samba Shadow Copies.

---- From: Ulli Horlacher <framstag@rus.uni-stuttgart.de> -- Sent: 2017-09-09 - 21:52 ----

> On Sat 2017-09-09 (22:43), Andrei Borzenkov wrote:
> 
>> > Your tool does not create .snapshot subdirectories in EVERY directory like
>> 
>> Neither does NetApp. Those "directories" are magic handles that do not
>> really exist.
> 
> I know.
> But symbolic links are the next close thing (I am not a kernel programmer).
> 
> 
>> Apart from obvious problem with recursive directory traversal (NetApp
>> .snapshot are not visible with normal directory list)
> 
> Yes, they are, at least sometimes, eg tar includes the snapshots.
> 
> 
> -- 
> Ullrich Horlacher              Server und Virtualisierung
> Rechenzentrum TIK         
> Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
> Allmandring 30a                Tel:    ++49-711-68565868
> 70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
> REF:<14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


