Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz25.laposte.net ([194.117.213.100]:52841 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753501AbdIRSCj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 14:02:39 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 5352610468C
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 20:02:37 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 46978105386
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 20:02:37 +0200 (CEST)
Received: from lpn-prd-vrin002 (lpn-prd-vrin002.laposte [10.128.63.3])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 4289D10468C
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 20:02:37 +0200 (CEST)
Received: from lpn-prd-vrin002 (localhost [127.0.0.1])
        by lpn-prd-vrin002 (Postfix) with ESMTP id 352515C365F
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 20:02:37 +0200 (CEST)
Subject: Re: cp --reflink and qgroup limit
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <d424bbbb-3c11-e874-9b12-4bae12e3d07e@laposte.net>
 <7eeb31e6-0145-2923-443e-e1e2b3bef79c@gmx.com>
From: Antoine Belvire <antoine.belvire@laposte.net>
Message-ID: <fc540011-caf6-ca44-3594-62ba4a90dbda@laposte.net>
Date: Mon, 18 Sep 2017 20:00:51 +0200
MIME-Version: 1.0
In-Reply-To: <7eeb31e6-0145-2923-443e-e1e2b3bef79c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Qu,

Le 18/09/2017 à 01:33, Qu Wenruo a écrit :
> That's a bug, and should be fixed.

OK.

> But it's a little complicated to fix.
> The biggest problem is, until reflink is done and we commit a 
> transaction, we don't know if the the reflink operation will increase 
> "rfer" or not.
> (Considering a case where both reflink source and destination is inside 
> the same subvolume)
> 
> Yes, we can always try to reserve the size of the data, and cause false 
> alert, but the handling of reserved data range will be another problem.
> 
> I'll check if we can solve it.

Thanks for your explanation. I'm looking forward to hearing good news 
about this then :)

Regards,

--
Antoine
