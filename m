Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66CCC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9E32083D
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbfCAQVW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:21:22 -0500
Received: from reasonset.net ([150.95.217.78]:43098 "EHLO mail.reasonset.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfCAQVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 11:21:22 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2019 11:21:21 EST
Received: from hydrangea (203-153-72-31.flets.kamome.or.jp [203.153.72.31])
        by mail.reasonset.net (Postfix) with ESMTPSA id 50A5B2201CF
        for <linux-btrfs@vger.kernel.org>; Sat,  2 Mar 2019 01:11:45 +0900 (JST)
Date:   Sat, 2 Mar 2019 01:11:52 +0900
From:   MASAKI Haruka <yek@reasonset.net>
To:     linux-btrfs@vger.kernel.org
Subject: Unable mount subvolume with "File exists" error
Message-ID: <20190302011152.2893c2f5@hydrangea>
Organization: Mimir Yokohamamai
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi.

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
