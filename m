Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:44974 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933729AbeFUXNd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 19:13:33 -0400
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:20098 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1fW8lf-0006jt-Tu
        for linux-btrfs@vger.kernel.org; Fri, 22 Jun 2018 01:13:31 +0200
To: linux-btrfs@vger.kernel.org
Reply-To: waxhead@dirtcellar.net
From: waxhead <waxhead@dirtcellar.net>
Subject: unsolvable technical issues?
Message-ID: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
Date: Fri, 22 Jun 2018 01:13:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to this:

https://stratis-storage.github.io/StratisSoftwareDesign.pdf
Page 4 , section 1.2

It claims that BTRFS still have significant technical issues that may 
never be resolved.
Could someone shed some light on exactly what these technical issues 
might be?! What are BTRFS biggest technical problems?

If you forget about the "RAID"5/6 like features then the only annoyances 
that I have with BTRFS so far is...

1. Lack of per subvolume "RAID" levels
2. Lack of not using the deviceid to re-discover and re-add dropped devices

And that's about it really...
