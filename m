Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.manjaro.org ([176.9.38.148]:36933 "EHLO manjaro.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdHHMVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Aug 2017 08:21:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by manjaro.org (Postfix) with ESMTP id 4B06D30C653D
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Aug 2017 13:59:59 +0200 (CEST)
Received: from manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wH50g2evukTS for <linux-btrfs@vger.kernel.org>;
        Tue,  8 Aug 2017 13:59:57 +0200 (CEST)
Subject: how to benchmark schedulers
References: <b5d1a891-efc0-e49e-ff91-4409c26491d2@manjaro.org>
To: linux-btrfs@vger.kernel.org
From: Bernhard Landauer <oberon@manjaro.org>
Message-ID: <751f296a-d26c-83a9-d105-e85f73fdcd06@manjaro.org>
Date: Tue, 8 Aug 2017 13:59:56 +0200
MIME-Version: 1.0
In-Reply-To: <b5d1a891-efc0-e49e-ff91-4409c26491d2@manjaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone

I am looking for a way to test different available schedulers with 
Manjaro's bfq-patched kernels on sytems with both SSD and spinning 
drives. Since phoronix-test-suite apparently is currently useless for 
this task due to its bad config for bfq I am looking for alternatives. 
Do you have any suggestions for me?
Thank you.

kind regards
Bernhard Landauer
