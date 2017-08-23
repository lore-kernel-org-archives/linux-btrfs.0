Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33369 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbdHWIhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 04:37:13 -0400
Received: by mail-lf0-f44.google.com with SMTP id d17so4431840lfe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 01:37:13 -0700 (PDT)
Received: from m37-2-118-254.cust.tele2.se ([2a00:801:218:b389:6d51:9642:6cdd:b122])
        by smtp.googlemail.com with ESMTPSA id 1sm162446ljg.80.2017.08.23.01.37.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256/256);
        Wed, 23 Aug 2017 01:37:09 -0700 (PDT)
Date: Wed, 23 Aug 2017 10:37:07 +0200 (GMT+02:00)
From: A L <crimsoncottage@gmail.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f75e66d.7ade2c40.15e0e3ced5c@gmail.com>
In-Reply-To: <20170823071821.GA28319@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de> <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com> <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu> <20170822165725.GL14804@rus.uni-stuttgart.de> <ab52f32.7ade2c3f.15e0af46ee9@gmail.com> <20170822180155.GM14804@rus.uni-stuttgart.de> <22940.31139.194399.982315@tree.ty.sabi.co.uk> <20170822204811.GO14804@rus.uni-stuttgart.de> <20170823071821.GA28319@rus.uni-stuttgart.de>
Subject: Re: number of subvolumes
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



---- From: Ulli Horlacher <framstag@rus.uni-stuttgart.de> -- Sent: 2017-08-23 - 09:18 ----

> On Tue 2017-08-22 (22:48), Ulli Horlacher wrote:
> 
>> > Assumptions that all Btrfs features such as snapshots are
>> > infinitely scalable at no cost may be optimistic:
>> > 
>> >   https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow
>> 
>> "when you do device removes on file systems with a lot of snapshots, it
>>  is unbelievably slow ... took nearly a week to move 20GB of FS data from
>>  one device to the other using that method"
>>   
>> "a balance on 2TB of data that was heavily snapshotted - it took 3 months" 
> 
> This is a vanilla SLES12 installation:
> 
> root@ptm1:~# grep PRETTY_NAME /etc/os-release 
> PRETTY_NAME="SUSE Linux Enterprise Server 12 SP1"
> 
> root@ptm1:~# btrfs subvolume list /
> ID 257 gen 358277 top level 5 path @
> ID 258 gen 978361 top level 257 path @/home
> ID 259 gen 1252501 top level 257 path @/opt
> ID 260 gen 883012 top level 257 path @/srv
> ID 261 gen 1252673 top level 257 path @/tmp
> ID 262 gen 1252501 top level 257 path @/usr/local
> ID 263 gen 882958 top level 257 path @/var/crash
> ID 264 gen 1252673 top level 257 path @/var/log
> ID 265 gen 882923 top level 257 path @/var/opt
> ID 266 gen 1252673 top level 257 path @/var/spool
> ID 267 gen 1252668 top level 257 path @/var/tmp
> ID 270 gen 1252668 top level 257 path @/.snapshots
> ID 452 gen 358277 top level 270 path @/.snapshots/127/snapshot
> ID 453 gen 1252670 top level 270 path @/.snapshots/128/snapshot
> ID 540 gen 368554 top level 270 path @/.snapshots/191/snapshot
> ID 542 gen 419566 top level 270 path @/.snapshots/192/snapshot
> ID 1035 gen 1027889 top level 270 path @/.snapshots/539/snapshot
> ID 1036 gen 1027889 top level 270 path @/.snapshots/540/snapshot
> ID 1045 gen 1048327 top level 270 path @/.snapshots/545/snapshot
> ID 1046 gen 1048327 top level 270 path @/.snapshots/546/snapshot
> ID 1062 gen 1068800 top level 270 path @/.snapshots/555/snapshot
> ID 1063 gen 1068800 top level 270 path @/.snapshots/556/snapshot
> ID 1122 gen 1130369 top level 270 path @/.snapshots/595/snapshot
> ID 1123 gen 1130369 top level 270 path @/.snapshots/596/snapshot
> ID 1124 gen 1171229 top level 270 path @/.snapshots/597/snapshot
> ID 1125 gen 1171229 top level 270 path @/.snapshots/598/snapshot
> ID 1135 gen 1171229 top level 270 path @/.snapshots/605/snapshot
> ID 1136 gen 1171229 top level 270 path @/.snapshots/606/snapshot
> ID 1137 gen 1171229 top level 270 path @/.snapshots/607/snapshot
> ID 1138 gen 1171229 top level 270 path @/.snapshots/608/snapshot
> ID 1139 gen 1171229 top level 270 path @/.snapshots/609/snapshot
> ID 1140 gen 1171229 top level 270 path @/.snapshots/610/snapshot
> ID 1141 gen 1171229 top level 270 path @/.snapshots/611/snapshot
> ID 1142 gen 1171229 top level 270 path @/.snapshots/612/snapshot
> ID 1158 gen 1172970 top level 270 path @/.snapshots/613/snapshot
> ID 1159 gen 1172972 top level 270 path @/.snapshots/614/snapshot
> 
> Why does SUSE ignore this "not too many subvolumes" warning?

Using hundreds or thousands of snapshots is probably fine mostly. perhaps the slow performance is more related to what changed between them? I have regularly that many snapshots and export many as "Previous Versions" to Windows clients over Samba without any performance issues. But my data doesn't change that much.

I think those comments on the Wiki are a little misleading without better details to what workloads are affected this way. 
Perhaps someone can set up some tests and publish the results?

> 
> 
> -- 
> Ullrich Horlacher              Server und Virtualisierung
> Rechenzentrum TIK         
> Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
> Allmandring 30a                Tel:    ++49-711-68565868
> 70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
> REF:<20170822204811.GO14804@rus.uni-stuttgart.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


