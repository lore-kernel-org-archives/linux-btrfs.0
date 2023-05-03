Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E082C77B75
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 May 2023 23:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjECXUj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 May 2023 19:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjECXUi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2023 19:20:38 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924F17A8D
        for <linux-btrfs@vger.kernel.org>; Wed,  3 May 2023 16:20:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id ED1C2588B2937; Thu,  4 May 2023 01:20:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id EB45860E41366;
        Thu,  4 May 2023 01:20:34 +0200 (CEST)
Date:   Thu, 4 May 2023 01:20:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Anand Jain <anand.jain@oracle.com>
cc:     linux-btrfs@vger.kernel.org
Subject: Re: Unprivileged snapshot removal after unpriv. snapshot creation
In-Reply-To: <e9edfc22-83e0-ff2e-cc8e-4d45047b7f02@oracle.com>
Message-ID: <q4onoqor-50qo-99nn-603q-97p48n6p176@vanv.qr>
References: <715r77s6-pp14-5q68-2258-nn87n1701no6@vanv.qr> <e9edfc22-83e0-ff2e-cc8e-4d45047b7f02@oracle.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wednesday 2023-05-03 11:13, Anand Jain wrote:

> Pls try using user_subvol_rm_allowed mount option.
>
>  mount -o remount,user_subvol_rm_allowed ...

Ah, too bad - the context I was/am working in is an unprivileged shell 
script that has no control over mount options.
But it was a good hint anyway, as the manpage points out one can
rm -Rf the directory to equally get rid of the snapshot.


thanks,
Jan
