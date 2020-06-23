Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EF1C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1428B20706
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592921448;
	bh=GmlilsWNJi3ZzM1zNWZ4xhjRlnSTeq4SN07a2LWueSI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UNsLZVtAv/7ZlnObv0Qw7z4vGuaZosAzAT83d+t/F2qHGEuM02sRGZj1LVDOoMwFj
	 EBsAZRG3w7Al39YLIPmxozi95VF2WGo5Nu3K8Pda5paugnwhihMcOTRu899DpAv8Tg
	 vXog8Zv83F4mHFMtXrYn5JySk8xmzIXaY0K7U8YU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732734AbgFWOKr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 10:10:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32922 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbgFWOKq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 10:10:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so20705543wru.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2020 07:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BpHvR6e867eLPhfTklzlEQPE0vSXJ1vGsznpfl3QVYU=;
        b=FN1QZjdxAtddkoFlAeCVNrJWLksABmc2IcIXlwhJQjudlYaGECJL/crk+/1MqUlrSW
         JlWtYF7DeiVPc3tDsCwtWIMyskzqfpD1KLGJk7uFgr1pWZpmNjl8A4Nwf/qX+/ThMndS
         FzMBEzxffYBqnADr8y0gUIcN7cBaNHWgYkH5CxEoauyLPVqeDyOq/Ro2i3tgM+SJbQjG
         REh2w8/zcp/ILgbG+3yhjjZtVhsAeL9+ycuTUhZNNUqXCbIHf3FpOzxAWyBJXFItxJ9L
         TrV0qgFDPGK6W7NvOPcGrZYF0nZGZCEl+w3aGhMvRj6OZ+Xq8GYfvyP6XmK761qdZHXT
         ycCA==
X-Gm-Message-State: AOAM531Tw52k0O+HDmHd8/l66DspEsjjKl6vNnmNYIwCPAQgMA4iQKNW
        +VBMKg2Ead3VEQPYJYV4uck5O8DU
X-Google-Smtp-Source: ABdhPJzdZHFNu8WHWFoSsjHDMbsj967T5wQaMwVat0C5p/mg9cFokjKZ/RP5TFYpAibrBtqjndwClg==
X-Received: by 2002:a5d:52c6:: with SMTP id r6mr24747266wrv.74.1592921444928;
        Tue, 23 Jun 2020 07:10:44 -0700 (PDT)
Received: from NUC.fritz.box ([2001:a62:1515:bd01:f64d:30ff:fe6c:acb5])
        by smtp.gmail.com with ESMTPSA id n1sm22529497wrp.10.2020.06.23.07.10.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 07:10:44 -0700 (PDT)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/4] btrfs-progs: get rid of btrfs_raid_profile_table
Date:   Tue, 23 Jun 2020 16:10:15 +0200
Message-Id: <20200623141019.23991-1-jth@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

As promised here's the removal of btrfs_raid_profile_table which helped as a
intermediate step to refactor the raid specific settings in block group
creation in progs.

As Qu remindet me of the outstanding debts this morning, I decided to go ahead
and pay my debt today.

It will not be the last refactoring round in this area though, as the
btrfs-progs side and the kernel side still diverge a lot.

This series passes a full 'make test' run from btrfs-progs.

Johannes Thumshirn (4):
  btrfs-progs: use sub_stripes property from btrfs_raid_attr
  btrfs-progs: use minimal number of stripes from btrfs_raid_attr
  btrfs-progs: remove unused btrfs_raid_profile::max_stripes
  btrfs-progs: remove btrfs_raid_profile_table

 volumes.c | 71 +++++--------------------------------------------------
 1 file changed, 6 insertions(+), 65 deletions(-)

-- 
2.26.2

