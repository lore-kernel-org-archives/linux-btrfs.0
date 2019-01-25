Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9A4C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B4C821919
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfAYIT5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:19:57 -0500
Received: from mout.gmx.net ([212.227.17.20]:45925 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfAYIT4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 03:19:56 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M0yaB-1h2xzo1iLH-00v9u0 for
 <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 09:19:55 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Subject: Re: kernel calltraces with btrfs and bonnie++
Date:   Fri, 25 Jan 2019 09:19:54 +0100
Message-ID: <23825602.kAPb5FHEL9@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <f3c5d32f-1af5-a73d-0980-b4464fe3cdfe@gmx.com>
References: <4998841.JdUrKLmerL@t460-skr> <14209521.serUsG5bZP@t460-skr> <f3c5d32f-1af5-a73d-0980-b4464fe3cdfe@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:r6Tbzdy8zoCDeXduvJ562l9mObDvfHdqUvJRcGR+R2r1q91EcyL
 wsy8zDp0pSsow/fxdF6Jof5cO0Yins7MvdJY/DMwfSOgnQRCN+FPKctJNvNwlcPY6gbg9rC
 EmvF/kWZubCVtM3Jwf1baB1VOFb+impUrcRykhknd7eukNhVXoipaM+TPmvPpFoePY/0orr
 KduORizkbhJDihXZTyKaw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QCxD4UgYVSE=:VDTeWxVm0pks+4NR1/8yI9
 I2PCS4LilrfH3tqsPxmjq169E0xqmuNY3icfil/mh6Lh7PTgkGSYp6QgoM9razPUHowIY72V3
 yaiEYptG2e+ujkgl04ERHD7Dz/L1brGNn6TZUQOG5ubqwWq9a8jshUZFr1D+tomBK+22m0ZfM
 73eGWhw5wz02LprtYFX6GYGjVxrFC2/thFYnYcSmLOebFHZJ1NHitVblxll1+NjIUXLmcfxXC
 OXqMiIWb57h0kThD36rw964IQG6WRV0y0jJb/ckS+aOkV9/i5ADnZnDygzKEF8PwoznwsxKZF
 JzZdCL8pvFx/UXNsvKJm9oultfePJh5thH7d/IfM2ORnd2oC7MS+TVmRj1tmsg4p09XHqDx9J
 5OD9SMVXdRB+zfw8jOI9ZUE8FKABfKQKm73E9QLNOXOBE4CF5MyXkW0xYMYvlgxBiwcslC9Ih
 xMSTYb3BgjNmCePW8TS7ETqoXXzVTZVRH7HjbpOwXBv/gBdXuxZ00hzFy+Ox6+cy8VRDpB9JS
 Rdv2UsYQfl/bJeQExNClwZfJCTdMMWXOeiGGHCnrcukhQjHDPqws426veSbiIhoTvoX03+s9L
 76ZMM2dEk6mXabsz4ptkpIa9nMb7Rr6qbXN8nd293VTeGYYPLn0NCQA++W7qVKCVu9/qKF7xi
 WJ1kyP1hmfW3Cv7xCthnunq1rafp3pmipJvBdPgQO2WfvTRYJwaKl/QX34ch2pJlHZzPkAx3a
 w+MCzEJFgHAa6+jRmnth/iT9l5c2Q1ZoGQVYlpVarxnthQuV38dzP+mH4Yl9bLImEyMWRQ8IF
 ZROFQBmAmBSk/00TcHAs5tYo3+lZhVd3cDVl3l7wLWFE7F53ze49/hse+ClcCk/5NEs8/bN3t
 mzcaYRwj+Noeh6eHbls2gnYh1Dhq0R0lPMrj7sS9ZzAKkx2O798ytNEEs9eRLjMRnHW6ryS+1
 UxrFwxHelVg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

so a simple
btrfs fi resize -4k /
do that trick?



On Friday, January 25, 2019 3:51:12 PM CET Qu Wenruo wrote:
> 
> On 2019/1/25 下午3:44, Stefan K wrote:
> > since it is my /-root FS its not possible to do that online?
> > 
> > 
> 
> 
> >> You could resize the fs by -4K and it should make the warning disappear.
> And since you have 2 devices, you need to resize each partition by -4K.
> 
> Thanks,
> Qu
> 
> 

