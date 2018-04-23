Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:33956 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932194AbeDWSZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 14:25:25 -0400
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:34085 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1fAg9T-0001dx-9a
        for linux-btrfs@vger.kernel.org; Mon, 23 Apr 2018 20:25:23 +0200
To: linux-btrfs@vger.kernel.org
Reply-To: waxhead@dirtcellar.net
From: waxhead <waxhead@dirtcellar.net>
Subject: libbrtfsutil questions
Message-ID: <003ad066-7544-e452-90ac-b2cad9cc1d06@dirtcellar.net>
Date: Mon, 23 Apr 2018 20:25:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy!

I am pondering writing a little C program that use libmicrohttpd and 
libbtrfsutil to display some very basic (overview) details about BTRFS.

I was hoping to display the same information that'btrfs fi sh /mnt' and 
'btrfs fi us -T /mnt' do, but somewhat combined. Since I recently just 
figured out how easy it was to do svg graphics I was hoping to try to 
visualize things a bit.

What I was hoping to achieve is:
- show all filesystems
- ..show all devices in a filesystem (and mark missing devices clearly)
- ....show usage and/or allocation for each device
- ....possibly display chunks as blocks (like old defrag programs) where 
the brightness indicate how utilied a (meta)data chunk is.
- ....possibly mark devices with errors ( 'btrfs de st /mnt' ).

The problem is ... I looked at libbtrfsutil and it appears that there is 
mostly sync + subvolume/snapshot stuff in there.

So my question is: Is libbtrfsutil the right choice and intended to at 
some point (in the future?) supply me with the data I need for these 
things or should I look elsewhere?

PS! This a completely private project for my own egoistic reasons. 
However if it turns out to be useful and the code is not too 
embarrassing I am happy put the code into public domain ... if it ever 
gets written.... :S







