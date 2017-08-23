Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:40446 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753300AbdHWG2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:28:38 -0400
Date: Wed, 23 Aug 2017 09:28:12 +0300
In-Reply-To: <20170822215343.GP14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de> <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com> <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu> <20170822165725.GL14804@rus.uni-stuttgart.de> <ab52f32.7ade2c3f.15e0af46ee9@gmail.com> <20170822180155.GM14804@rus.uni-stuttgart.de> <22940.31139.194399.982315@tree.ty.sabi.co.uk> <20170822215343.GP14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: user snapshots
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Message-ID: <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>Also in https://btrfs.wiki.kernel.org/index.php/Mount_options
>"user_subvol_rm_allowed (...) Use with caution."
>
>Why? What is the problem?

Because with the mount option any user can delete any subvolume, including root one (subvol_id=5)
