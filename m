Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33070 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762048AbcINOku (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 10:40:50 -0400
Received: by mail-qk0-f196.google.com with SMTP id n66so1185353qkf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 07:40:45 -0700 (PDT)
Message-ID: <1473864030.21017.3.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Josef Bacik <jbacik@fb.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Date: Wed, 14 Sep 2016 11:40:30 -0300
In-Reply-To: <41e0d253-133f-ac0e-eda6-95a927736fc6@fb.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57D76FB0.4060908@cn.fujitsu.com> <1473799768.3344.1.camel@gmail.com>
         <41e0d253-133f-ac0e-eda6-95a927736fc6@fb.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Em Ter, 2016-09-13 às 17:01 -0400, Josef Bacik escreveu:
> I just started paying attention to this, the last kernel I saw you
> were running 
> was 4.7.  Have you tried a recent kernel, like chris's tree?
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> for-linus-4.8
> 
> is what I would like you to try if not.  Thanks,
> 
> Josef

Unfortunately, since this is a production machine, I am not allowed to
install unreleased kernels. If this is the only solution, I will need
to wait for 4.8 or search if anyone has already backported the BTRFS
patches for 4.7.

Best regards,
Ronan Arraes
