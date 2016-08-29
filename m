Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36590 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756089AbcH2ASy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 20:18:54 -0400
Received: by mail-oi0-f42.google.com with SMTP id f189so176642577oig.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 17:18:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com> <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
From: Gareth Pye <gareth@cerberos.id.au>
Date: Mon, 29 Aug 2016 10:18:53 +1000
Message-ID: <CA+WRLO8XVaK5FK9VUt=pOgoyqYm30_yxTnCd+5zdYx5Xx6jAcw@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am I right that the wr: 0 means that the disks should at least be in a
nice consistent state? I know that overlapping read fails can still
cause everything to fail.
