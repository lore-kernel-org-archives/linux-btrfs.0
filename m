Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB548C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E1021924
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfBHHdM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:33:12 -0500
Received: from mout.gmx.net ([212.227.15.19]:57079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfBHHdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 02:33:12 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Meg8W-1gTs6A1fa4-00OKAt for
 <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 08:33:10 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Reply-To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs as / filesystem in RAID1
Date:   Fri, 08 Feb 2019 08:33:09 +0100
Message-ID: <2369797.IGv3eFWPI5@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
References: <33679024.u47WPbL97D@t460-skr> <2840929.O1qc6pvfHa@merkaba> <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:p9+H0CdduTb8sp9tvQ6ByJsCLIsa1LukFyREUhMO6oNBr4u6c2k
 +UKXyP3YT3mzncxqGyKr+WysGtkWNcOExEfJDJvm/+BhsFQTaOY45xlGQBlF1/LbJ9/Fwtj
 J3LQ+7S6I84oqmpzMJW6xtXA6Pt6afA9GVcS6m3bG5HPJ2O2KacFjO+hIgTNQ4Wv4ZC3Qwq
 cWxeEnavo+pux2/VsVqkg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:s3+P7ZheK5o=:8AotvwMQ/FnI8YRG6fJDSl
 2JstQ8kF33SS6vgh7exKFPNRK/hDGoISd3wYlqfGrQyhtSQLG+R6UuTD86KGtOrLzwQyjqhKq
 1Vtz+imOFOnvzkVQe64D4Rr3bQOe5GTlqVHwK6DFVS67s4xY2RlxT7smQNJT0897IIQy+1SMb
 h6eAksluUPtnTJGD+wSuOZLX8g3OshcblgMS3/YYExl4P5SzMzWS3k56jFXJ23UlDxauyAJSR
 0R2fHGr1nSPinbkWdWxddWPOv82UfKa0OEAVWVPLOdclqb1paFoaWba1BcU05nKGRJl40+M5m
 BvawePpdQurhCmf22yhjoUbpQct5MQDXlaRp4e8Mj8f8d1jzXjH+Vz8NpG03FumZIjsjcdFy2
 AKE2FcZKPS5xDPwucBTogOQyOcrFTmWE7cuLbetr1lfyDUYEnu+JWqQfuHR40kBPkzt45ITwJ
 DAnhRP7YosZdnZhVHWTPY648hnmoxiG9eXBio6rVxo9lrxu9LrDBAM6ypIsfqJ4KoRZ9+7EEW
 1KnJSKK8LEYztQ2KNO2grT6CkOLkb96kTV1PNTQ03iidxEvp0H6EeBvVggXmWwNdebvBvwwDv
 8329XMs5H88YnFwPlXkiHGV7nBF7mmy+4hKqllZbo6Kv39DciwpR4jM7XFhuOfx3HyOyUVmd0
 bQbvS4ci66WQOzpBY4bpfr7cO1nyOkJdzKE8kVXHYAYdB7KcIjshIa4P6RyZP+4CKolY/0rDe
 vC5x0V/RerwlHV/zuaY5r/WmUYd33ud9ubCfyIhyafUCR9IMXqVi5eJmlB0mNhx8Yy+cH27Sd
 0OC0HsuKUID2bwE63aD2ECPZ1X+YsQ3WmJMr0VFkkXfWn5n2Lc1I+6ZeagWvZ6had2CUxKrCB
 heKMusswg/ztcpTE6npW8Lu10ES4rEPSL7ZLppD6x4+xoBvmbcupTBdg/yRj2ewykg/WTAMoJ
 0n8HVy/Lqvg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> However the raid1 term only describes replication. It doesn't describe
> any policy.
yep you're right, but the most sysadmin expect some 'policies'. 

If I use RAID1 I expect that if one drive failed, I can still  boot _without_ boot issues, just some warnings etc, because I use raid1 to have simple 1device tolerance if one fails (which can happen). I can check/monitor the BTRFS RAID status by 'btrfs fi sh' or '(or by 'btrfs dev stat'). I also expect that if a device came back it will sync automatically and if I replace a device it will automatically rebalance the raid1 (which btrfs does, so far). I think a lot of sysadmins feel the same way.


On Thursday, February 7, 2019 3:19:01 PM CET Chris Murphy wrote:
> On Thu, Feb 7, 2019 at 10:37 AM Martin Steigerwald <martin@lichtvoll.de> wrote:
> >
> > Chris Murphy - 07.02.19, 18:15:
> > > > So please change the normal behavior
> > >
> > > In the case of no device loss, but device delay, with 'degraded' set
> > > in fstab you risk a non-deterministic degraded mount. And there is no
> > > automatic balance (sync) after recovering from a degraded mount. And
> > > as far as I know there's no automatic transition from degraded to
> > > normal operation upon later discovery of a previously missing device.
> > > It's just begging for data loss. That's why it's not the default.
> > > That's why it's not recommended.
> >
> > Still the current behavior is not really user-friendly. And does not
> > meet expectations that users usually have about how RAID 1 works. I know
> > BTRFS RAID 1 is no RAID 1, although it is called like this.
> 
> I mentioned the user experience is not good, in both my Feb 2 and Feb
> 5 responses, compared to mdadm and lvm raid1 in the same situation.
> 
> However the raid1 term only describes replication. It doesn't describe
> any policy. And whether to fail to mount or mount degraded by default,
> is a policy. Whether and how to transition from degraded to normal
> operation when a formerly missing device reappears, is a policy. And
> whether, and how, and when to rebuild data after resuming normal
> operation is a policy. A big part of why these policies are MIA is
> because they require features that just don't exist yet. And perhaps
> don't even belong in btrfs kernel code or user space tools; but rather
> a system service or daemon that manages such policies. However, none
> of that means Btrfs raid1 is not raid1. There's a wrong assumption
> being made about policies and features in mdadm and LVM, that they are
> somehow attached to the definition of raid1, but they aren't.
> 
> 
> > I also somewhat get that with the current state of BTRFS the current
> > behavior of not allowing a degraded mount may be better… however… I see
> > clearly room for improvement here. And there very likely will be
> > discussions like this on this list… until BTRFS acts in a more user
> > friendly way here.
> 
> And it's completely appropriate if someone wants to  update the Btrfs
> status page to make more clear what features/behaviors/policies apply
> to Btrfs raid of all types, or to have a page that summarizes their
> differences among mdadm and/or LVM raid levels, so users can better
> assess their risk taking, and choose the best Linux storage technology
> for their use case.
> 
> But at least developers know this is the case.
> 
> And actually, you could mitigate some decent amount of Btrfs missing
> features with server monitoring tools; including parsing kernel
> messages. Because right now you aren't even informed of read or write
> errors, device or csums mismatches or fixups, unless you're checking
> kernel messages. Where mdadm has the option for emailing notifications
> to an admin for such things, and lvm has a monitor that I guess does
> something I haven't used it. Literally Btrfs will only complain about
> failed writes that would cause immediate ejection of the device by md.
> 
> 
> 
> 

