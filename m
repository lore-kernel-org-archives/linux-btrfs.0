Return-Path: <SRS0=hmSb=RG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A82C43381
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Mar 2019 12:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A518320857
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Mar 2019 12:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inflaton.co.jp header.i=@inflaton.co.jp header.b="Y22EC506"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfCCMmj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 Mar 2019 07:42:39 -0500
Received: from mailgw1.conoha.ne.jp ([163.44.187.12]:64109 "EHLO
        mailgw1.conoha.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfCCMmj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2019 07:42:39 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2019 07:42:38 EST
Received: from mail1.conoha.ne.jp (unknown [172.16.42.13])
        by mailgw1.conoha.ne.jp (Postfix) with ESMTP id E02FB18013351F
        for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2019 21:36:05 +0900 (JST)
Received: from hydrangea (203-153-72-31.flets.kamome.or.jp [203.153.72.31])
        by mail1.conoha.ne.jp (Postfix) with ESMTPSA id BBB4920146776
        for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2019 21:36:05 +0900 (JST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail1.conoha.ne.jp BBB4920146776
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inflaton.co.jp;
        s=default; t=1551616565;
        bh=fSAsEQ0xiDoLX+h1ivkglGoZ7PQmeli5ZBjfnCxd0K8=;
        h=Date:From:To:Subject:From;
        b=Y22EC506MRDr7p4uwJ3DQjXfFckaWygYr6z5xmGd19eFOnaHXmIAcJFA1lrEw8NBR
         e1PpuQUs2HggSmmzDLtleRXllbzigvdmJAxkUrd8s4ZEif8ytW61gkkhOtIJ92q8us
         8p9pHo1HnUxC36A8Bs1tbUKay0oKUeR0h5hKvdPqHkOijUJWDlg3sloSDq+OaL1/eW
         AC6Jt+1V1kMmp3158R6x6OaXoc5r8Bb2dOGxdfxwXjd6ik3s42/PIfYakWbjejmcW0
         WbZBFOcBLA/0uMU8Z9LivL2BWjGZGS8/C5bZcTibJ+I7jEJlLNgUu+ZJYkjTH4UNLG
         MOPpKF3P7D01Q==
Date:   Sun, 3 Mar 2019 21:36:19 +0900
From:   MASAKI Haruka <reasonset@inflaton.co.jp>
To:     <linux-btrfs@vger.kernel.org>
Subject: Unable mount subvolume with "File exists" error
Message-ID: <20190303213619.0b581733@hydrangea>
Organization: Inflaton, Inc.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When run this script

***
#!/bin/zsh
setopt RC_EXPAND_PARAM

if [[ $1 == start ]]
then 
  if iscsiadm -m node -L all && mount /mnt/worldvol && mount /MasterVol && mount ~foo/local
  ...
***

failed with
mount: /MasterVol: mount(2) system call failed: File exists.
message after last month Manjaro update.

in /etc/fstab

***
LABEL=MasterBtr                           /MasterVol     btrfs   defaults,relatime,space_cache,compress=lzo,subvol=world,noauto 0 0
LABEL=MasterBtr                           /mnt/worldvol  btrfs   defaults,relatime,space_cache,compress=lzo,noauto 0 0
/MasterVol/local                          /home/foo/local none   rbind,noauto 0 0
***

I could mount every volume by unmount /mnt/worldvol and mount each volume manually, but the script always failed with "File exists."
