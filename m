Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7012C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30F93206C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inflaton.co.jp header.i=@inflaton.co.jp header.b="jNDLzFvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfDYNnF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:43:05 -0400
Received: from mailgw1-55.conoha.ne.jp ([163.44.187.55]:23974 "EHLO
        mailgw1.conoha.ne.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbfDYNnF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 09:43:05 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2019 09:43:04 EDT
Received: from mail1.conoha.ne.jp (unknown [172.16.42.13])
        by mailgw1.conoha.ne.jp (Postfix) with ESMTP id 2CBCC180135709
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 22:34:26 +0900 (JST)
Received: from hydrangea (p191169-ipngn6801hodogaya.kanagawa.ocn.ne.jp [124.87.185.169])
        by mail1.conoha.ne.jp (Postfix) with ESMTPSA id 03D1B200CD4C4
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 22:34:25 +0900 (JST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail1.conoha.ne.jp 03D1B200CD4C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inflaton.co.jp;
        s=default; t=1556199266;
        bh=dU3S1vRM+p5uyG5BscSiRoZuBKKXbo/5N1p94lq9q88=;
        h=Date:From:To:Subject:From;
        b=jNDLzFvrQrNcXtiWEqdidxJ8PUzYxrTo/lgMOnrLhmoq/lDqI2wa7AxY3eITNLN2L
         NNB34gZB4tR/R0AZBX5KDGODAFTcj3Y8WWWdNHvocVRJe5CmfjbnfnN9E2DeZjD8qa
         51Wq1oUjdXH7QpsraOrOLX1RivVvHJN/xeIKhX/xLPcViNJobskv27UI5XAgZzxTno
         9e3wpH6rsg8+Qbq/7kwIgGWRDWPADXEBW39skrHfnI3HPyKUQjguSy5nfckqAVxu2I
         vfYA1pgbOWzXv2j0Lfy1PJlGnEe8h5sq7OYkVBjERVWDJZqjKxoEaskg8stu4qTesi
         EJZxEWOMl5xTw==
Date:   Thu, 25 Apr 2019 22:34:57 +0900
From:   MASAKI Haruka <reasonset@inflaton.co.jp>
To:     linux-btrfs@vger.kernel.org
Subject: Some file lost when send back snapshot.
Message-ID: <20190425223457.5a7dfd20@hydrangea>
Organization: Inflaton, Inc.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I send snapshot from backup volume, and send new snaopshot to backup volume,
and some file lost in received volume.

In detail:

1. Host A has new Btrfs volume and Host B have two backuped readonly subvolumes (190312-010100, 190315-001000).
2. Host B send 190315-001000 subvolume to Host A.
3. Host A completely received (all files exist.)
4. Host B took new readonly snapshot "back1" on 190315-001000 (all files exist.)
5. Host B send back1 with `-p 190315-001000` to Host A (some file lost.)
6. Host B took new read-writable snapshot "world" on back1 (all files exist.)
7. Host B modified world.
8. Host B took new readonly snapshot "back2" on world (all files exist.)
9. Host B send back2 with `-p 190315-001000` to Host A (some file lost.)
10. Deleted received snapshot and Host B send back2 with `-p back1` to Host A (some file lost.)

Kernel
5.0.5-1-MANJARO

Btrfs progs
btrfs-progs 4.20.2-1


What I should do?

Thanks.



Masaki Haruka
