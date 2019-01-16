Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214D2C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 15:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A3120675
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 15:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404932AbfAPPeR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:34:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:59979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfAPPeR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 10:34:17 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LgeFd-1h4bLp11JV-00nxr7 for
 <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 16:34:16 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: roadmap for btrfs
Date:   Wed, 16 Jan 2019 16:34:15 +0100
Message-ID: <2488171.qjqVUjIhQd@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:ZHgGzdZrygXHaY9F6rmN9uNE2f0CuM4W1zeGbId2FxJAUqt+Sta
 /NpO9dwlYSMYT+mg5NTr1Zg8LMsDsq+vXCS+4XNezKdAUp5t2s2gZHPlIhZn7xxwde6x2HI
 FrJN4LzuHyJxPk5ZvM9H641VVfrCX/9ohauIF0G69ckh8s5/snGwwfD8IqxfOWYYcy0EJ8a
 LKpMw754dVnAy9kcyCBBw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BmhdAFby7Ps=:nS3a6Qz4Ci4tg4hdE2aoTi
 7FPmJbzhAiD/BiBO97LycOSvbWNomLGBqizUS/UtXZzobOrsTz6ygIh5oaLCbjc5L0D6xQquY
 BA9vrhqVVXpe3bGdeRTN15G3OT5wuV46p9t+8v11ggFHj1wBISh0I96jHTkizdFeE4icJVQgy
 eRy0aGwI3IbCLfcvyWqx/AWPdQMdx5LViTArS/8FBzEr/H3EeCAQO4acikUOKwh6/Ac88HjUX
 Sec07TpyqhPVfDfbIyOUfHYc+WlIRI2tpjDjZWhGCti1V/fWNs0sZzMPAiD9wHvOZtsHiekpT
 1Qbw4rVHHmMawrgS/S+5RY1OV+69SzMaBB4wecwGaTjr2Xl16NFs6CTw0twN9VlUTzWDML53O
 xx7Irhk3LqCNzsDpvgg5cdDmmyCRdTWVegIVAbuvVtxG+JKkwRohMrD2NSjiBKEIK3SrGaafo
 vEDQ1IYyXtbw9wB1eaNw818Qu1BlGY4UOpT9q3ojFIyKh0tAwFf2QpMGcP12X8cdaQd5T6kUz
 MHwx9XfY3L7/MM6RyJoZlLBAYvbUkilyp8UUeu5GWL1TH4FaAbOk1WTZofLssOelL2Y51DwU4
 YVPR42AxH0U+wdWjpooYdOw/9AvVN1+Yd0C7O9WTipYVn4upbKcV2GVW7r5qsvc5wdc+b1u80
 Am5NMGrRZfJCkd5FS8qyuX9J73fuiGzeY78bNsouUMO8MHHnnE9hberuL8gth+EZtpbqufg2T
 rSJ0uwdcq1KvmDoxtC9UkKOhY2VllufVbEqrCnJjnjkPnO0SPh0LcF6Gy5ppBZZgZTyceYlK/
 bsVPef0m1l9CUcqDGskCMlltLfHA0PcK47hvHBQDvSyy02C5yrRtv7yWC1kUmGEURY2Gr9kfW
 awKF29KbQlb9gadvr5yRPT1Ao8oLQjSvorSrDuvDAu+qudN1hP3Nq2dUkBro5qhBnN4Gywo51
 24ajQlRkjhA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

does exist an roadmap or something like "what do first/next"?
I saw the project ideas[1] and there are a lot of intersting things in it (like read/write caches, per subvolumes mount options, block devices, etc), but there is no plan or an order of ideas. Did btrfs has something like that?

[1] https://btrfs.wiki.kernel.org/index.php/Project_ideas

best regards 
Stefan
