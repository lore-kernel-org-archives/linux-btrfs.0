Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35577 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdHVRTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 13:19:12 -0400
Received: by mail-lf0-f51.google.com with SMTP id k186so26510051lfe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 10:19:11 -0700 (PDT)
Received: from m90-144-246-126.cust.tele2.se ([2a00:801:211:351c:79a:db66:e896:2ddc])
        by smtp.googlemail.com with ESMTPSA id 1sm2808118lju.63.2017.08.22.10.19.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256/256);
        Tue, 22 Aug 2017 10:19:07 -0700 (PDT)
Date: Tue, 22 Aug 2017 19:19:04 +0200 (GMT+02:00)
From: A L <crimsoncottage@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
In-Reply-To: <20170822165725.GL14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de> <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com> <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu> <20170822165725.GL14804@rus.uni-stuttgart.de>
Subject: Re: netapp-alike snapshots?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Perhaps using a bind mount? It would look and work the same as a ordinary fs. Just need to make sure du uses one filesystem.

---- From: Ulli Horlacher <framstag@rus.uni-stuttgart.de> -- Sent: 2017-08-22 - 18:57 ----

> On Tue 2017-08-22 (21:45), Roman Mamedov wrote:
> 
>> It is beneficial to not have snapshots in-place. With a local directory of
>> snapshots, issuing things like "find", "grep -r" or even "du" will take an
>> inordinate amount of time and will produce a result you do not expect.
> 
> Netapp snapshots are invisible for tools doing opendir()/readdir()
> One could simulate this with symlinks for the snapshot directory:
> store the snapshot elsewhere (not inplace) and create a symlink to it, in
> every directory.
> 
> 
>> Personally I prefer to have a /snapshots directory on every FS
> 
> My users want the snapshots locally in a .snapshot subdirectory.
> Because Netapp do it this way - for at least 20 years and we have a
> multi-PB Netapp storage environment.
> No chance to change this.
> 
> -- 
> Ullrich Horlacher              Server und Virtualisierung
> Rechenzentrum TIK         
> Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
> Allmandring 30a                Tel:    ++49-711-68565868
> 70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
> REF:<20170822214531.44538589@natsu>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


