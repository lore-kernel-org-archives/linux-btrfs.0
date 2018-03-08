Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:43528 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934059AbeCHKgn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 05:36:43 -0500
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:40878 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1etsug-0006dI-0A
        for linux-btrfs@vger.kernel.org; Thu, 08 Mar 2018 11:36:42 +0100
To: linux-btrfs@vger.kernel.org
Reply-To: waxhead@dirtcellar.net
From: waxhead <waxhead@dirtcellar.net>
Subject: Per subvolume "RAID" level?!
Message-ID: <cd82d247-5c95-18cd-a290-a911ff69613c@dirtcellar.net>
Date: Thu, 8 Mar 2018 11:36:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just out of curiosity, are there any work going on for enabling 
different "RAID" levels per subvolume?!

And out of even more curiosity how is this planned to be handled with 
btrfs balance?! When per subvolume "RAID" levels are good to go, how 
would you then run the balance filters to convert / leave alone certain 
parts of the filesystem?!
